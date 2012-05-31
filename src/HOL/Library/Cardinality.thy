(*  Title:      HOL/Library/Cardinality.thy
    Author:     Brian Huffman, Andreas Lochbihler
*)

header {* Cardinality of types *}

theory Cardinality
imports "~~/src/HOL/Main"
begin

subsection {* Preliminary lemmas *}
(* These should be moved elsewhere *)

lemma (in type_definition) univ:
  "UNIV = Abs ` A"
proof
  show "Abs ` A \<subseteq> UNIV" by (rule subset_UNIV)
  show "UNIV \<subseteq> Abs ` A"
  proof
    fix x :: 'b
    have "x = Abs (Rep x)" by (rule Rep_inverse [symmetric])
    moreover have "Rep x \<in> A" by (rule Rep)
    ultimately show "x \<in> Abs ` A" by (rule image_eqI)
  qed
qed

lemma (in type_definition) card: "card (UNIV :: 'b set) = card A"
  by (simp add: univ card_image inj_on_def Abs_inject)


subsection {* Cardinalities of types *}

syntax "_type_card" :: "type => nat" ("(1CARD/(1'(_')))")

translations "CARD('t)" => "CONST card (CONST UNIV \<Colon> 't set)"

typed_print_translation (advanced) {*
  let
    fun card_univ_tr' ctxt _ [Const (@{const_syntax UNIV}, Type (_, [T, _]))] =
      Syntax.const @{syntax_const "_type_card"} $ Syntax_Phases.term_of_typ ctxt T;
  in [(@{const_syntax card}, card_univ_tr')] end
*}

lemma card_unit [simp]: "CARD(unit) = 1"
  unfolding UNIV_unit by simp

lemma card_prod [simp]: "CARD('a \<times> 'b) = CARD('a::finite) * CARD('b::finite)"
  unfolding UNIV_Times_UNIV [symmetric] by (simp only: card_cartesian_product)

lemma card_sum [simp]: "CARD('a + 'b) = CARD('a::finite) + CARD('b::finite)"
  unfolding UNIV_Plus_UNIV [symmetric] by (simp only: finite card_Plus)

lemma card_option [simp]: "CARD('a option) = Suc CARD('a::finite)"
  unfolding UNIV_option_conv
  apply (subgoal_tac "(None::'a option) \<notin> range Some")
  apply (simp add: card_image)
  apply fast
  done

lemma card_set [simp]: "CARD('a set) = 2 ^ CARD('a::finite)"
  unfolding Pow_UNIV [symmetric]
  by (simp only: card_Pow finite)

lemma card_nat [simp]: "CARD(nat) = 0"
  by (simp add: card_eq_0_iff)


subsection {* Classes with at least 1 and 2  *}

text {* Class finite already captures "at least 1" *}

lemma zero_less_card_finite [simp]: "0 < CARD('a::finite)"
  unfolding neq0_conv [symmetric] by simp

lemma one_le_card_finite [simp]: "Suc 0 \<le> CARD('a::finite)"
  by (simp add: less_Suc_eq_le [symmetric])

text {* Class for cardinality "at least 2" *}

class card2 = finite + 
  assumes two_le_card: "2 \<le> CARD('a)"

lemma one_less_card: "Suc 0 < CARD('a::card2)"
  using two_le_card [where 'a='a] by simp

lemma one_less_int_card: "1 < int CARD('a::card2)"
  using one_less_card [where 'a='a] by simp

subsection {* A type class for computing the cardinality of types *}

class card_UNIV = 
  fixes card_UNIV :: "'a itself \<Rightarrow> nat"
  assumes card_UNIV: "card_UNIV x = card (UNIV :: 'a set)"
begin

lemma card_UNIV_neq_0_finite_UNIV:
  "card_UNIV x \<noteq> 0 \<longleftrightarrow> finite (UNIV :: 'a set)"
by(simp add: card_UNIV card_eq_0_iff)

lemma card_UNIV_ge_0_finite_UNIV:
  "card_UNIV x > 0 \<longleftrightarrow> finite (UNIV :: 'a set)"
by(auto simp add: card_UNIV intro: card_ge_0_finite finite_UNIV_card_ge_0)

lemma card_UNIV_eq_0_infinite_UNIV:
  "card_UNIV x = 0 \<longleftrightarrow> \<not> finite (UNIV :: 'a set)"
by(simp add: card_UNIV card_eq_0_iff)

definition is_list_UNIV :: "'a list \<Rightarrow> bool"
where "is_list_UNIV xs = (let c = card_UNIV (TYPE('a)) in if c = 0 then False else size (remdups xs) = c)"

lemma is_list_UNIV_iff: fixes xs :: "'a list"
  shows "is_list_UNIV xs \<longleftrightarrow> set xs = UNIV"
proof
  assume "is_list_UNIV xs"
  hence c: "card_UNIV (TYPE('a)) > 0" and xs: "size (remdups xs) = card_UNIV (TYPE('a))"
    unfolding is_list_UNIV_def by(simp_all add: Let_def split: split_if_asm)
  from c have fin: "finite (UNIV :: 'a set)" by(auto simp add: card_UNIV_ge_0_finite_UNIV)
  have "card (set (remdups xs)) = size (remdups xs)" by(subst distinct_card) auto
  also note set_remdups
  finally show "set xs = UNIV" using fin unfolding xs card_UNIV by-(rule card_eq_UNIV_imp_eq_UNIV)
next
  assume xs: "set xs = UNIV"
  from finite_set[of xs] have fin: "finite (UNIV :: 'a set)" unfolding xs .
  hence "card_UNIV (TYPE ('a)) \<noteq> 0" unfolding card_UNIV_neq_0_finite_UNIV .
  moreover have "size (remdups xs) = card (set (remdups xs))"
    by(subst distinct_card) auto
  ultimately show "is_list_UNIV xs" using xs by(simp add: is_list_UNIV_def Let_def card_UNIV)
qed

lemma card_UNIV_eq_0_is_list_UNIV_False:
  assumes cU0: "card_UNIV x = 0"
  shows "is_list_UNIV = (\<lambda>xs. False)"
proof(rule ext)
  fix xs :: "'a list"
  from cU0 have "\<not> finite (UNIV :: 'a set)"
    by(auto simp only: card_UNIV_eq_0_infinite_UNIV)
  moreover have "finite (set xs)" by(rule finite_set)
  ultimately have "(UNIV :: 'a set) \<noteq> set xs" by(auto simp del: finite_set)
  thus "is_list_UNIV xs = False" unfolding is_list_UNIV_iff by simp
qed

end

subsection {* Instantiations for @{text "card_UNIV"} *}

subsubsection {* @{typ "nat"} *}

instantiation nat :: card_UNIV begin

definition "card_UNIV_class.card_UNIV = (\<lambda>a :: nat itself. 0)"

instance proof
  fix x :: "nat itself"
  show "card_UNIV x = card (UNIV :: nat set)"
    unfolding card_UNIV_nat_def by simp
qed

end

subsubsection {* @{typ "int"} *}

instantiation int :: card_UNIV begin

definition "card_UNIV = (\<lambda>a :: int itself. 0)"

instance proof
  fix x :: "int itself"
  show "card_UNIV x = card (UNIV :: int set)"
    unfolding card_UNIV_int_def by(simp add: infinite_UNIV_int)
qed

end

subsubsection {* @{typ "'a list"} *}

instantiation list :: (type) card_UNIV begin

definition "card_UNIV = (\<lambda>a :: 'a list itself. 0)"

instance proof
  fix x :: "'a list itself"
  show "card_UNIV x = card (UNIV :: 'a list set)"
    unfolding card_UNIV_list_def by(simp add: infinite_UNIV_listI)
qed

end

subsubsection {* @{typ "unit"} *}

instantiation unit :: card_UNIV begin

definition "card_UNIV = (\<lambda>a :: unit itself. 1)"

instance proof
  fix x :: "unit itself"
  show "card_UNIV x = card (UNIV :: unit set)"
    by(simp add: card_UNIV_unit_def card_UNIV_unit)
qed

end

subsubsection {* @{typ "bool"} *}

instantiation bool :: card_UNIV begin

definition "card_UNIV = (\<lambda>a :: bool itself. 2)"

instance proof
  fix x :: "bool itself"
  show "card_UNIV x = card (UNIV :: bool set)"
    by(simp add: card_UNIV_bool_def card_UNIV_bool)
qed

end

subsubsection {* @{typ "char"} *}

lemma card_UNIV_char: "card (UNIV :: char set) = 256"
proof -
  from enum_distinct
  have "card (set (Enum.enum :: char list)) = length (Enum.enum :: char list)"
    by (rule distinct_card)
  also have "set Enum.enum = (UNIV :: char set)" by (auto intro: in_enum)
  also note enum_chars
  finally show ?thesis by (simp add: chars_def)
qed

instantiation char :: card_UNIV begin

definition "card_UNIV_class.card_UNIV = (\<lambda>a :: char itself. 256)"

instance proof
  fix x :: "char itself"
  show "card_UNIV x = card (UNIV :: char set)"
    by(simp add: card_UNIV_char_def card_UNIV_char)
qed

end

subsubsection {* @{typ "'a \<times> 'b"} *}

instantiation prod :: (card_UNIV, card_UNIV) card_UNIV begin

definition "card_UNIV = (\<lambda>a :: ('a \<times> 'b) itself. card_UNIV (TYPE('a)) * card_UNIV (TYPE('b)))"

instance proof
  fix x :: "('a \<times> 'b) itself"
  show "card_UNIV x = card (UNIV :: ('a \<times> 'b) set)"
    by(simp add: card_UNIV_prod_def card_UNIV UNIV_Times_UNIV[symmetric] card_cartesian_product del: UNIV_Times_UNIV)
qed

end

subsubsection {* @{typ "'a + 'b"} *}

instantiation sum :: (card_UNIV, card_UNIV) card_UNIV begin

definition "card_UNIV_class.card_UNIV = (\<lambda>a :: ('a + 'b) itself. 
  let ca = card_UNIV (TYPE('a)); cb = card_UNIV (TYPE('b))
  in if ca \<noteq> 0 \<and> cb \<noteq> 0 then ca + cb else 0)"

instance proof
  fix x :: "('a + 'b) itself"
  show "card_UNIV x = card (UNIV :: ('a + 'b) set)"
    by (auto simp add: card_UNIV_sum_def card_UNIV card_eq_0_iff UNIV_Plus_UNIV[symmetric] finite_Plus_iff Let_def card_Plus simp del: UNIV_Plus_UNIV dest!: card_ge_0_finite)
qed

end

subsubsection {* @{typ "'a \<Rightarrow> 'b"} *}

instantiation "fun" :: (card_UNIV, card_UNIV) card_UNIV begin

definition "card_UNIV = 
  (\<lambda>a :: ('a \<Rightarrow> 'b) itself. let ca = card_UNIV (TYPE('a)); cb = card_UNIV (TYPE('b))
                            in if ca \<noteq> 0 \<and> cb \<noteq> 0 \<or> cb = 1 then cb ^ ca else 0)"

instance proof
  fix x :: "('a \<Rightarrow> 'b) itself"

  { assume "0 < card (UNIV :: 'a set)"
    and "0 < card (UNIV :: 'b set)"
    hence fina: "finite (UNIV :: 'a set)" and finb: "finite (UNIV :: 'b set)"
      by(simp_all only: card_ge_0_finite)
    from finite_distinct_list[OF finb] obtain bs 
      where bs: "set bs = (UNIV :: 'b set)" and distb: "distinct bs" by blast
    from finite_distinct_list[OF fina] obtain as
      where as: "set as = (UNIV :: 'a set)" and dista: "distinct as" by blast
    have cb: "card (UNIV :: 'b set) = length bs"
      unfolding bs[symmetric] distinct_card[OF distb] ..
    have ca: "card (UNIV :: 'a set) = length as"
      unfolding as[symmetric] distinct_card[OF dista] ..
    let ?xs = "map (\<lambda>ys. the o map_of (zip as ys)) (Enum.n_lists (length as) bs)"
    have "UNIV = set ?xs"
    proof(rule UNIV_eq_I)
      fix f :: "'a \<Rightarrow> 'b"
      from as have "f = the \<circ> map_of (zip as (map f as))"
        by(auto simp add: map_of_zip_map intro: ext)
      thus "f \<in> set ?xs" using bs by(auto simp add: set_n_lists)
    qed
    moreover have "distinct ?xs" unfolding distinct_map
    proof(intro conjI distinct_n_lists distb inj_onI)
      fix xs ys :: "'b list"
      assume xs: "xs \<in> set (Enum.n_lists (length as) bs)"
        and ys: "ys \<in> set (Enum.n_lists (length as) bs)"
        and eq: "the \<circ> map_of (zip as xs) = the \<circ> map_of (zip as ys)"
      from xs ys have [simp]: "length xs = length as" "length ys = length as"
        by(simp_all add: length_n_lists_elem)
      have "map_of (zip as xs) = map_of (zip as ys)"
      proof
        fix x
        from as bs have "\<exists>y. map_of (zip as xs) x = Some y" "\<exists>y. map_of (zip as ys) x = Some y"
          by(simp_all add: map_of_zip_is_Some[symmetric])
        with eq show "map_of (zip as xs) x = map_of (zip as ys) x"
          by(auto dest: fun_cong[where x=x])
      qed
      with dista show "xs = ys" by(simp add: map_of_zip_inject)
    qed
    hence "card (set ?xs) = length ?xs" by(simp only: distinct_card)
    moreover have "length ?xs = length bs ^ length as" by(simp add: length_n_lists)
    ultimately have "card (UNIV :: ('a \<Rightarrow> 'b) set) = card (UNIV :: 'b set) ^ card (UNIV :: 'a set)"
      using cb ca by simp }
  moreover {
    assume cb: "card (UNIV :: 'b set) = Suc 0"
    then obtain b where b: "UNIV = {b :: 'b}" by(auto simp add: card_Suc_eq)
    have eq: "UNIV = {\<lambda>x :: 'a. b ::'b}"
    proof(rule UNIV_eq_I)
      fix x :: "'a \<Rightarrow> 'b"
      { fix y
        have "x y \<in> UNIV" ..
        hence "x y = b" unfolding b by simp }
      thus "x \<in> {\<lambda>x. b}" by(auto intro: ext)
    qed
    have "card (UNIV :: ('a \<Rightarrow> 'b) set) = Suc 0" unfolding eq by simp }
  ultimately show "card_UNIV x = card (UNIV :: ('a \<Rightarrow> 'b) set)"
    unfolding card_UNIV_fun_def card_UNIV Let_def
    by(auto simp del: One_nat_def)(auto simp add: card_eq_0_iff dest: finite_fun_UNIVD2 finite_fun_UNIVD1)
qed

end

subsubsection {* @{typ "'a option"} *}

instantiation option :: (card_UNIV) card_UNIV
begin

definition "card_UNIV = (\<lambda>a :: 'a option itself. let c = card_UNIV (TYPE('a)) in if c \<noteq> 0 then Suc c else 0)"

instance proof
  fix x :: "'a option itself"
  show "card_UNIV x = card (UNIV :: 'a option set)"
    unfolding UNIV_option_conv
    by(auto simp add: card_UNIV_option_def card_UNIV card_eq_0_iff Let_def intro: inj_Some dest: finite_imageD)
      (subst card_insert_disjoint, auto simp add: card_eq_0_iff card_image inj_Some intro: finite_imageI card_ge_0_finite)
qed

end

subsection {* Code setup for equality on sets *}

definition eq_set :: "'a :: card_UNIV set \<Rightarrow> 'a :: card_UNIV set \<Rightarrow> bool"
where [simp, code del]: "eq_set = op ="

lemmas [code_unfold] = eq_set_def[symmetric]

lemma card_Compl:
  "finite A \<Longrightarrow> card (- A) = card (UNIV :: 'a set) - card (A :: 'a set)"
by (metis Compl_eq_Diff_UNIV card_Diff_subset top_greatest)

lemma eq_set_code [code]:
  fixes xs ys :: "'a :: card_UNIV list"
  defines "rhs \<equiv> 
  let n = card_UNIV TYPE('a)
  in if n = 0 then False else 
        let xs' = remdups xs; ys' = remdups ys 
        in length xs' + length ys' = n \<and> (\<forall>x \<in> set xs'. x \<notin> set ys') \<and> (\<forall>y \<in> set ys'. y \<notin> set xs')"
  shows "eq_set (List.coset xs) (set ys) \<longleftrightarrow> rhs" (is ?thesis1)
  and "eq_set (set ys) (List.coset xs) \<longleftrightarrow> rhs" (is ?thesis2)
  and "eq_set (set xs) (set ys) \<longleftrightarrow> (\<forall>x \<in> set xs. x \<in> set ys) \<and> (\<forall>y \<in> set ys. y \<in> set xs)" (is ?thesis3)
  and "eq_set (List.coset xs) (List.coset ys) \<longleftrightarrow> (\<forall>x \<in> set xs. x \<in> set ys) \<and> (\<forall>y \<in> set ys. y \<in> set xs)" (is ?thesis4)
proof -
  show ?thesis1 (is "?lhs \<longleftrightarrow> ?rhs")
  proof
    assume ?lhs thus ?rhs
      by(auto simp add: rhs_def Let_def List.card_set[symmetric] card_Un_Int[where A="set xs" and B="- set xs"] card_UNIV Compl_partition card_gt_0_iff dest: sym)(metis finite_compl finite_set)
  next
    assume ?rhs
    moreover have "\<lbrakk> \<forall>y\<in>set xs. y \<notin> set ys; \<forall>x\<in>set ys. x \<notin> set xs \<rbrakk> \<Longrightarrow> set xs \<inter> set ys = {}" by blast
    ultimately show ?lhs
      by(auto simp add: rhs_def Let_def List.card_set[symmetric] card_UNIV card_gt_0_iff card_Un_Int[where A="set xs" and B="set ys"] dest: card_eq_UNIV_imp_eq_UNIV split: split_if_asm)
  qed
  thus ?thesis2 unfolding eq_set_def by blast
  show ?thesis3 ?thesis4 unfolding eq_set_def List.coset_def by blast+
qed

(* test code setup *)
value [code] "List.coset [True] = set [False] \<and> set [] = List.coset [True, False]"

end
