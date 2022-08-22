cd "/Users/abc/Desktop/110-2/RA/Social Nerwork/Result/reg_result"

clear 
eststo clear


//use "/Users/abc/Desktop/110-2/RA/Social Nerwork/page_centrality_with_info.dta"
import delimited "/Users/abc/Desktop/110-2/RA/Social Nerwork/Result/with_politicians/community_aggregation/page_centrality_with_info.csv"

rename week week_temp
gen week = date(week_temp, "YMD")
drop week_temp

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

// try adding debate time dummy

// add time dummy where presidential debate took place
gen is_debate = 0
replace is_debate = 1 if week==date("2016/09/25", "YMD")

gen is_debate_lead1 = 0
replace is_debate_lead1 = 1 if week==date("2016/10/02", "YMD")

gen is_debate_lead2 = 0
replace is_debate_lead2 = 1 if week==date("2016/10/09", "YMD")

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
		quietly xtreg degree_centrality fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe
		
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
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

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
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

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
		quietly xtreg degree_centrality fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

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
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

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
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

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
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate is_debate_lead1 is_debate_lead2, fe

bysort ideology_from_community: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_after_debate, fe
esttab , mti
eststo clear
