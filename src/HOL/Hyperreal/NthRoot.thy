(*  Title       : NthRoot.thy
    Author      : Jacques D. Fleuriot
    Copyright   : 1998  University of Cambridge
    Description : Existence of nth root. Adapted from
                   http://www.math.unl.edu/~webnotes
*)

header{*Existence of Nth Root*}

theory NthRoot = SEQ + HSeries:

text{*Various lemmas needed for this result. We follow the proof
   given by John Lindsay Orr (jorr@math.unl.edu) in his Analysis
   Webnotes available on the www at http://www.math.unl.edu/~webnotes
   Lemmas about sequences of reals are used to reach the result.*}

lemma lemma_nth_realpow_non_empty:
     "[| (0::real) < a; 0 < n |] ==> \<exists>s. s : {x. x ^ n <= a & 0 < x}"
apply (case_tac "1 <= a")
apply (rule_tac x = "1" in exI)
apply (drule_tac [2] linorder_not_le [THEN iffD1])
apply (drule_tac [2] less_not_refl2 [THEN not0_implies_Suc])
apply (auto intro!: realpow_Suc_le_self simp add: zero_less_one)
done

lemma lemma_nth_realpow_isUb_ex:
     "[| (0::real) < a; 0 < n |]  
      ==> \<exists>u. isUb (UNIV::real set) {x. x ^ n <= a & 0 < x} u"
apply (case_tac "1 <= a")
apply (rule_tac x = "a" in exI)
apply (drule_tac [2] linorder_not_le [THEN iffD1])
apply (rule_tac [2] x = "1" in exI)
apply (rule_tac [!] setleI [THEN isUbI])
apply safe
apply (simp_all (no_asm))
apply (rule_tac [!] ccontr)
apply (drule_tac [!] linorder_not_le [THEN iffD1])
apply (drule realpow_ge_self2 , assumption)
apply (drule_tac n = "n" in realpow_less)
apply (assumption+)
apply (drule real_le_trans , assumption)
apply (drule_tac y = "y ^ n" in order_less_le_trans)
apply (assumption , erule real_less_irrefl)
apply (drule_tac n = "n" in zero_less_one [THEN realpow_less])
apply auto
done

lemma nth_realpow_isLub_ex:
     "[| (0::real) < a; 0 < n |]  
      ==> \<exists>u. isLub (UNIV::real set) {x. x ^ n <= a & 0 < x} u"
apply (blast intro: lemma_nth_realpow_isUb_ex lemma_nth_realpow_non_empty reals_complete)
done
 
subsection{*First Half -- Lemmas First*}

lemma lemma_nth_realpow_seq:
     "isLub (UNIV::real set) {x. x ^ n <= a & (0::real) < x} u  
           ==> u + inverse(real (Suc k)) ~: {x. x ^ n <= a & 0 < x}"
apply (safe , drule isLubD2 , blast)
apply (simp add: real_le_def)
done

lemma lemma_nth_realpow_isLub_gt_zero:
     "[| isLub (UNIV::real set) {x. x ^ n <= a & (0::real) < x} u;  
         0 < a; 0 < n |] ==> 0 < u"
apply (drule lemma_nth_realpow_non_empty , auto)
apply (drule_tac y = "s" in isLub_isUb [THEN isUbD])
apply (auto intro: order_less_le_trans)
done

lemma lemma_nth_realpow_isLub_ge:
     "[| isLub (UNIV::real set) {x. x ^ n <= a & (0::real) < x} u;  
         0 < a; 0 < n |] ==> ALL k. a <= (u + inverse(real (Suc k))) ^ n"
apply (safe)
apply (frule lemma_nth_realpow_seq , safe)
apply (auto elim: real_less_asym simp add: real_le_def)
apply (simp add: real_le_def [symmetric])
apply (rule order_less_trans [of _ 0])
apply (auto intro: lemma_nth_realpow_isLub_gt_zero)
done

text{*First result we want*}
lemma realpow_nth_ge:
     "[| (0::real) < a; 0 < n;  
     isLub (UNIV::real set)  
     {x. x ^ n <= a & 0 < x} u |] ==> a <= u ^ n"
apply (frule lemma_nth_realpow_isLub_ge , safe)
apply (rule LIMSEQ_inverse_real_of_nat_add [THEN LIMSEQ_pow, THEN LIMSEQ_le_const])
apply (auto simp add: real_of_nat_def)
done

subsection{*Second Half*}

lemma less_isLub_not_isUb:
     "[| isLub (UNIV::real set) S u; x < u |]  
           ==> ~ isUb (UNIV::real set) S x"
apply (safe)
apply (drule isLub_le_isUb)
apply assumption
apply (drule order_less_le_trans)
apply (auto simp add: real_less_not_refl)
done

lemma not_isUb_less_ex:
     "~ isUb (UNIV::real set) S u ==> \<exists>x \<in> S. u < x"
apply (rule ccontr , erule swap)
apply (rule setleI [THEN isUbI])
apply (auto simp add: real_le_def)
done

lemma real_mult_less_self: "0 < r ==> r * (1 + -inverse(real (Suc n))) < r"
apply (simp (no_asm) add: right_distrib)
apply (rule add_less_cancel_left [of "-r", THEN iffD1])
apply (auto intro: mult_pos
            simp add: add_assoc [symmetric] neg_less_0_iff_less)
done

lemma real_mult_add_one_minus_ge_zero:
     "0 < r ==>  0 <= r*(1 + -inverse(real (Suc n)))"
apply (simp add: zero_le_mult_iff real_of_nat_inverse_le_iff) 
apply (simp add: real_of_nat_Suc) 
done

lemma lemma_nth_realpow_isLub_le:
     "[| isLub (UNIV::real set) {x. x ^ n <= a & (0::real) < x} u;  
       0 < a; 0 < n |] ==> ALL k. (u*(1 + -inverse(real (Suc k)))) ^ n <= a"
apply (safe)
apply (frule less_isLub_not_isUb [THEN not_isUb_less_ex])
apply (rule_tac n = "k" in real_mult_less_self)
apply (blast intro: lemma_nth_realpow_isLub_gt_zero)
apply (safe)
apply (drule_tac n = "k" in lemma_nth_realpow_isLub_gt_zero [THEN real_mult_add_one_minus_ge_zero])
apply (drule_tac [3] conjI [THEN realpow_le2])
apply (rule_tac [3] order_less_imp_le) 
apply (auto intro: order_trans)
done

text{*Second result we want*}
lemma realpow_nth_le:
     "[| (0::real) < a; 0 < n;  
     isLub (UNIV::real set)  
     {x. x ^ n <= a & 0 < x} u |] ==> u ^ n <= a"
apply (frule lemma_nth_realpow_isLub_le , safe)
apply (rule LIMSEQ_inverse_real_of_nat_add_minus_mult [THEN LIMSEQ_pow, THEN LIMSEQ_le_const2])
apply (auto simp add: real_of_nat_def)
done

(*----------- The theorem at last! -----------*)
lemma realpow_nth: "[| (0::real) < a; 0 < n |] ==> \<exists>r. r ^ n = a"
apply (frule nth_realpow_isLub_ex , auto)
apply (auto intro: realpow_nth_le realpow_nth_ge real_le_anti_sym)
done

(* positive only *)
lemma realpow_pos_nth: "[| (0::real) < a; 0 < n |] ==> \<exists>r. 0 < r & r ^ n = a"
apply (frule nth_realpow_isLub_ex , auto)
apply (auto intro: realpow_nth_le realpow_nth_ge real_le_anti_sym lemma_nth_realpow_isLub_gt_zero)
done

lemma realpow_pos_nth2: "(0::real) < a  ==> \<exists>r. 0 < r & r ^ Suc n = a"
apply (blast intro: realpow_pos_nth)
done

(* uniqueness of nth positive root *)
lemma realpow_pos_nth_unique:
     "[| (0::real) < a; 0 < n |] ==> EX! r. 0 < r & r ^ n = a"
apply (auto intro!: realpow_pos_nth)
apply (cut_tac x = "r" and y = "y" in linorder_less_linear)
apply auto
apply (drule_tac x = "r" in realpow_less)
apply (drule_tac [4] x = "y" in realpow_less)
apply (auto simp add: real_less_not_refl)
done

ML
{*
val nth_realpow_isLub_ex = thm"nth_realpow_isLub_ex";
val realpow_nth_ge = thm"realpow_nth_ge";
val less_isLub_not_isUb = thm"less_isLub_not_isUb";
val not_isUb_less_ex = thm"not_isUb_less_ex";
val realpow_nth_le = thm"realpow_nth_le";
val realpow_nth = thm"realpow_nth";
val realpow_pos_nth = thm"realpow_pos_nth";
val realpow_pos_nth2 = thm"realpow_pos_nth2";
val realpow_pos_nth_unique = thm"realpow_pos_nth_unique";
*}

end
