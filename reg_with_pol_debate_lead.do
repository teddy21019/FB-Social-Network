cd "/Users/abc/Desktop/110-2/RA/Social Nerwork/Result/reg_result"

clear 
eststo clear


//use "/Users/abc/Desktop/110-2/RA/Social Nerwork/page_centrality_with_info.dta"
import delimited "/Users/abc/Desktop/110-2/RA/Social Nerwork/Result/with_politicians/community_aggregation/page_centrality_with_info.csv"

rename week week_temp
gen week = date(week_temp, "YMD")

rename degree_centrality c_temp
gen degree_centrality = c_temp * 100
drop c_temp

rename eigenvector_centrality c_temp
gen eigenvector_centrality =  c_temp * 100
drop c_temp

rename unweighted_eigenvector_centralit c_temp
gen unweighted_eigenvector_centralit =  c_temp * 100
drop c_temp

rename closeness_centrality c_temp
gen closeness_centrality =  c_temp * 100
drop c_temp

xtset page_id week

// drop missing value
drop if fan_count == .
quietly sum fan_count, detail
gen fan_scale = "large"
replace fan_scale = "small" if fan_count <= r(p50)

// try adding debate time dummy

// add time dummy where presidential debate took place
gen is_debate = 0
replace is_debate = 1 if week==date("2016/09/25", "YMD")

gen is_debate_lag1 = 0
replace is_debate_lag1 = 1 if week==date("2016/10/02", "YMD")

gen is_debate_lag2 = 0
replace is_debate_lag2 = 1 if week==date("2016/10/09", "YMD")

gen is_after_debate = 0
replace is_after_debate = 1 if week>=date("2016/09/25", "YMD")

gen ideology_type = ""
replace ideology_type = "Right" if page_ideo_full_year > 0
replace ideology_type = "Left" if page_ideo_full_year < 0












// do panel data regression by subtypes
// can't include fixed effect due to collinearity of page info


bysort type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_debate, fe
esttab, mti
eststo clear

bysort type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_after_debate, fe
esttab, mti
eststo clear
//====================

//try using other centralities

		// no debate dummy vs debate dummy
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear
//====================
		// no debate dummy vs debate dummy
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear
//====================


//Group by Ideology

//====================
		// no debate dummy vs debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear

//====================
		// no debate dummy vs debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear

//====================
		// no debate dummy vs debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum, fe

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear


// Ideology doesn't seem to affect the tendency of centrality change. Facebook fan page
// type is more significant.

bysort ideology_from_community: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum, fe

bysort ideology_from_community: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate, fe
esttab , mti
eststo clear

		// debate lead dummy vs after debate dummy
bysort ideology_from_community: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lag1 is_debate_lag2, fe

bysort ideology_from_community: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear







//======================================
//
//
//				Using Lag and Depreciation
//
//======================================

					//+++++++++++++++++++++++++++++++++
					//
					//
					//				By type
					//
					//+++++++++++++++++++++++++++++++++
										di "By Type : Eigenvector Centrality -- Depreciated"
// eigen					
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Depreciated : 0.1") mti width(100%) r ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))


//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

}



// unweighted
					di "By Type : Unweighted Eigenvector Centrality -- Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

}



// degree
					di "By Type : Degree Centrality --  Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate, fe

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate, fe

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

}



					di "By Type : Eigenvector Centrality -- Lagged and Depreciated"

// eigen
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Lagged and Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_ is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Lagged and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_type.html", title("Eigenvector Centrality -- Lagged and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

}



// unweighted
					di "By Type : Unweighted Eigenvector Centrality -- Lagged and Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Lagged and Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Lagged and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_after_debate, fe
esttab using "ld_type.html", title("Unweighted Eigenvector Centrality -- Lagged and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0))

}



// degree
					di "By Type : Degree Centrality -- Lagged and Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Lagged and Depreciated : 0.1") mti width(100%) a
//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Lagged and Depreciated : 0.5") mti width(100%) a
//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate, fe

bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_type.html", title("Degree Centrality -- Lagged and Depreciated : 0.9") mti width(100%) a
}






					//+++++++++++++++++++++++++++++++++
					//
					//
					//				By Ideology
					//
					//+++++++++++++++++++++++++++++++++
					
					di "By Ideology : Eigenvector Centrality -- Depreciated"
// eigen					
quietly{
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_after_debate, fe
		
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Depreciated : 0.1") mti width(100%) r ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_after_debate, fe
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// unweighted
					di "By Ideology : Unweighted Eigenvector Centrality -- Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_after_debate, fe
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.1") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_after_debate, fe
		
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.5") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_after_debate, fe
		
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.9") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// degree
					di "By Ideology : Degree Centrality -- Depreciated"
quietly{
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
}

					di "By Ideology : Degree Centrality -- Lag and Depreciated"
// eigen
quietly{
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_after_debate, fe
		
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.1") mti width(100%) r ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_after_debate, fe
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_ideo.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// unweighted
					di "By Ideology : Unweighted Eigenvector Centrality -- Lag and Depreciated"
quietly{
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_after_debate, fe
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.1") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
//====================
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_after_debate, fe
		
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.5") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_after_debate, fe
		
esttab using "ld_ideo.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.9") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// degree
					di "By Ideology : Degree Centrality -- Depreciated"
quietly{
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Lag and Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Lag and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate, fe

bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort ideology_type: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_ideo.html", title("Degree Centrality -- Lag and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
}



					//+++++++++++++++++++++++++++++++++
					//
					//
					//			By Fan Base
					//
					//
					//++++++++++++++++++++++++++++++++++
// eigen				
					di "By Fan Base : Eigenvector Centrality -- Depreciated"
quietly{
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1 is_after_debate, fe
		
esttab using "ld_fan.html", title("Eigenvector Centrality -- Depreciated : 0.1") mti width(100%) r ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_fan.html", title("Eigenvector Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9 is_after_debate, fe
esttab using "ld_fan.html", title("Eigenvector Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// unweighted
					di "By Fan Base : Unweighted Eigenvector Centrality -- Depreciated"
quietly{
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1 is_after_debate, fe
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.1") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
//====================
eststo clear
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5 is_after_debate, fe
		
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.5") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate, fe

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9 is_after_debate, fe
		
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Depreciated : 0.9") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// degree
					di "By Fan Base : Degree Centrality -- Depreciated"
quietly{
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1 is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5 is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9 is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
}

					di "By Fan Base : Degree Centrality -- Lag and Depreciated"
// eigen
quietly{
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p1_l is_after_debate, fe
		
esttab using "ld_fan.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.1") mti width(100%) r ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p5_l is_after_debate, fe
esttab using "ld_fan.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg eigenvector_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_fan.html", title("Eigenvector Centrality -- Lag and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// unweighted
	 				di "By Fan Base : Unweighted Eigenvector Centrality -- Lag and Depreciated"
quietly{
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p1_l is_after_debate, fe
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.1") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
//====================
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p5_l is_after_debate, fe
		
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.5") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit  fake_count_p9_l is_after_debate, fe
		
esttab using "ld_fan.html", title("Unweighted Eigenvector Centrality -- Lag and Depreciated : 0.9") ///
		mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

}



// degree
					di "By Fan Base : Degree Centrality -- Depreciated"
quietly{
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p1_l is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Lag and Depreciated : 0.1") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p5_l is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Lag and Depreciated : 0.5") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))

//====================
eststo clear

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate, fe

bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_debate is_debate_lag1 is_debate_lag2, fe
		
bysort fan_scale: eststo: ///
		quietly xtreg degree_centrality  fake_count_p9_l is_after_debate, fe
esttab using "ld_fan.html", title("Degree Centrality -- Lag and Depreciated : 0.9") mti width(100%) a ///
		mgroups("No debate" "Debate" "Debate with Lag" "After Debate", pattern(1 0 1 0 1 0 1 0))
}

					


//======================================
//
//
//			Quantile Regression for Panel Data
//
//======================================

					//+++++++++++++++++++++++++++++++++
					//
					//
					//				Lag and depreciated
					//
					//+++++++++++++++++++++++++++++++++
quietly ///
{
eststo clear
eststo, title("0.9 depr, Lag, Q90"): ///				
		qregpd unweighted_eigenvector_centralit fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.9 depr, Lag, Q10"): ///				
		qregpd unweighted_eigenvector_centralit fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)

eststo, title("0.1 depr, Lag, Q90"): ///				
		qregpd unweighted_eigenvector_centralit fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.1 depr, Lag, Q10"): ///				
		qregpd unweighted_eigenvector_centralit fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)
		
}
esttab, mti title("Unweighted Eigenvector Centrality -- Quantile regression for lagged accumulation")
esttab using "ecqrla.html", title("Unweighted Eigenvector Centrality -- Quantile regression for lagged accumulation") mti width(100%) r
quietly ///
{
eststo clear
eststo, title("0.9 depr, Lag, Q90"): ///				
		qregpd eigenvector_centrality fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.9 depr, Lag, Q10"): ///				
		qregpd eigenvector_centrality fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)

eststo, title("0.1 depr, Lag, Q90"): ///				
		qregpd eigenvector_centrality fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.1 depr, Lag, Q10"): ///				
		qregpd eigenvector_centrality fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)
		
}
esttab, mti title("Eigenvector Centrality -- Quantile regression for lagged accumulation")
esttab using "ecqrla.html", title("Eigenvector Centrality -- Quantile regression for lagged accumulation") mti width(100%) a

quietly ///
{
eststo clear
eststo, title("0.9 depr, Lag, Q90"): ///				
		qregpd degree_centrality fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.9 depr, Lag, Q10"): ///				
		qregpd degree_centrality fake_count_p9_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)

eststo, title("0.1 depr, Lag, Q90"): ///				
		qregpd degree_centrality fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.9) optimize("mcmc") burn(200)
		
eststo, title("0.1 depr, Lag, Q10"): ///				
		qregpd degree_centrality fake_count_p1_l is_debate is_debate_lag1, ///
		id(page_id) fix(week) q(0.1) optimize("mcmc") burn(200)
		
}
esttab, mti title("Dgree Centrality -- Quantile regression for lagged accumulation")
esttab using "ecqrla.html", title("Dgree Centrality -- Quantile regression for lagged accumulation") mti width(100%) a
