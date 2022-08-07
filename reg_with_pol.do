cd "/Users/abc/Desktop/110-2/RA/Social Nerwork/Result/reg_result"

clear 
eststo clear


use "/Users/abc/Desktop/110-2/RA/Social Nerwork/page_centrality_with_info.dta"

rename week week_temp
gen week = date(week_temp, "YMD")
drop week_temp

xtset page_id week

// drop missing value
drop if fan_count == .

// try adding debate time dummy

// add time dummy where presidential debate took place
gen is_debate = 0
replace is_debate = 1 if week==date("2016/09/25", "YMD")

// do panel data regression by subtypes
// can't include fixed effect due to collinearity of page info

bysort type: eststo: ///
		xtreg degree_centrality fake_posts_cum
		
bysort type: eststo: ///
		quietly xtreg degree_centrality fake_posts_cum is_debate
esttab using "deg_c.html", mti
eststo clear

//====================

//try using other centralities
bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum

bysort type: eststo: ///
		quietly xtreg eigenvector_centrality fake_posts_cum is_debate
esttab using "eig_c.html", mti
eststo clear
//====================
bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum

bysort type: eststo: ///
		quietly xtreg unweighted_eigenvector_centralit fake_posts_cum is_debate
esttab using "uneig_c.html", mti
eststo clear
//====================

bysort type: eststo: ///
		quietly xtreg closeness_centrality fake_posts_cum


bysort type: eststo: ///
		quietly xtreg closeness_centrality fake_posts_cum is_debate
esttab using "close_c.html", mti
eststo clear

