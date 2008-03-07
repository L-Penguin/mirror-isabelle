(*  Title:      HOL/Library/Option_ord.thy
    ID:         $Id$
    Author:     Florian Haftmann, TU Muenchen
*)

header {* Canonical order on option type *}

theory Option_ord
imports ATP_Linkup
begin

instantiation option :: (order) order
begin

definition less_eq_option where
  [code func del]: "x \<le> y \<longleftrightarrow> (case x of None \<Rightarrow> True | Some x \<Rightarrow> (case y of None \<Rightarrow> False | Some y \<Rightarrow> x \<le> y))"

definition less_option where
  [code func del]: "x < y \<longleftrightarrow> (case y of None \<Rightarrow> False | Some y \<Rightarrow> (case x of None \<Rightarrow> True | Some x \<Rightarrow> x < y))"

lemma less_eq_option_None [simp]: "None \<le> (x\<Colon>'a option)"
  by (simp add: less_eq_option_def)

lemma less_eq_option_None_code [code]: "None \<le> (x\<Colon>'a option) \<longleftrightarrow> True"
  by simp

lemma less_eq_option_None_is_None: "(x\<Colon>'a option) \<le> None \<Longrightarrow> x = None"
  by (cases x) (simp_all add: less_eq_option_def)

lemma less_eq_option_Some_None [simp, code]: "Some (x\<Colon>'a) \<le> None \<longleftrightarrow> False"
  by (simp add: less_eq_option_def)

lemma less_eq_option_Some [simp, code]: "Some (x\<Colon>'a) \<le> Some y \<longleftrightarrow> x \<le> y"
  by (simp add: less_eq_option_def)

lemma less_option_None [simp, code]: "(x\<Colon>'a option) < None \<longleftrightarrow> False"
  by (simp add: less_option_def)

lemma less_option_None_is_Some: "None < (x\<Colon>'a option) \<Longrightarrow> \<exists>z. x = Some z"
  by (cases x) (simp_all add: less_option_def)

lemma less_option_None_Some [simp]: "None < Some (x\<Colon>'a)"
  by (simp add: less_option_def)

lemma less_option_None_Some_code [code]: "None < Some (x\<Colon>'a) \<longleftrightarrow> True"
  by simp

lemma less_option_Some [simp, code]: "Some (x\<Colon>'a) < Some y \<longleftrightarrow> x < y"
  by (simp add: less_option_def)

instance by default
  (auto simp add: less_eq_option_def less_option_def split: option.splits)

end 

instance option :: (linorder) linorder
  by default (auto simp add: less_eq_option_def less_option_def split: option.splits)

end
