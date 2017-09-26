libname mydata "/courses/d1406ae5ba27fe300 " access=readonly;

data stepnout; set mydata.stepnout;

label 	
	csex = "Gender" /*c, 2*/
	cond = "CBM or Standard Parole" /*c,2*/
	clive = "Living Condition" /*c,8*/
	livsp = "Lives With Spouse" /*c,2,m*/
	jobsp = "Spouse Job" /*c,4,m*/
	cmstat = "Marital Status" /*c,6*/
	hs = "Graduated HS" /*c,2,m*/
	job = "Has Job" /*c,11,m*/
	drvlic = "Has Drivers License" /*c,2,m*/
	majsup = "Major Support" /*c,13,m*/
	gangev = "Ever in Gang" /*c,2,m*/
	ganc = "Currently in Gang" /*c,2,m*/
	painlf = "Pain in Lifetime" /*c,2*/
	dprslf = "Depression in Lifetime" /*c,2*/
	anxlf = "Anxiety in Lifetime" /*c,2*/
	hallulf = "Hallucinations in Lifetime" /*c,2*/
	conclf = "Concentration Issues in Lifetime" /*c,2*/
	viollf = "Violence Issues in Lifetime" /*c,2*/
	sidelf = "Suicidal Thoughts in Lifetime" /*c,2,m*/
	sattlf = "Suicide Attempt in Lifetime" /*c,2*/
	msdp1= "Most Serious Drug Prior To Incarceration" /*c,20,m*/
	tcutot = "TCU Score" /*n,m*/
	parole_violation = "Parole Violation at 9 Months" /*c,2*/
	reincarc_9mo = "Reincarcerated at 9 Months" /*c,2*/
	drug_charge = "Drug Charge at 9 Months" /*c,2*/
	arrest_9mo = "Arrested at 9 Months" /*c,2*/
	age = "Age" /*n*/
	arstlf = "Number of Arrests in Lifetime" /*n,m*/
	minorch = "Number of Minor Children" /*n,m*/
	age1ar = "Age at First Arrest" /*n,m*/
	arstjv = "Number of Juvenile Arrests"  /*n,m*/
	arstdrg = "Number of Drug Arrests"/*n,m*/
	livch = "Number of ChildrenLiving With (Last 6 Months) "
	supch = "Number of Children Receiving Support (Last 6 Months)"
	fostch = "Number of Children in Foster Care(Last 6 Months)";


proc freq data = stepnout;
tables csex age cond clive livsp jobsp cmstat hs job drvlic majsup gangev gangc
painlf dprslf anxlf hallulf conclf viollf sidelf sattlf msdp1 tcutot 
arstlf minorch age1ar arstjv arstdrg livch supch fostch
parole_violation reincarc_9mo arrest_9mo drug_charge;
run;

proc means data = stepnout N Mean Std Min Q1 Median Q3 Max STACKODSOUTPUT; 
ods output Summary=MeansSummary; 
var arstlf minorch age1ar arstjv arstdrg tcutot livch supch fostch;
run;

/*manage missing values*/
data stepnout;
set stepnout;
if livsp = . then livsp = 99;
if jobsp = . then jobsp = 99;
if hs = . then hs = 99;
if job = . then job = 99;
if drvlic = . then drvlic = 99;
if gangev = . then gangev = 99;
if gangc = . then gangc = 99;
if majsup = . then majsup = 99;
if sidelf = . then sidelf = 99;
if tcutot = . then tcutot = 8; /*sub the median*/
if arstlf = . then arstlf = 8; /*sub the median*/
if minorch = . then minorch = 1; /*sub the median*/
if age1ar = . then age1ar = 17; /*sub the median*/
if arstjv = . then arstjv = 1; /*sub the median*/
if arstdrg = . then arstdrg = 5;/*sub the median*/
if livch = . then livch = 0;
if supch = . and minorch GT 0 then supch = 1; 
if supch = . and minorch <= 0 then supch = 0;
if fostch = . then fostch = 0;
if msdp1 = . then msdp1 = 99;
run;

proc freq data = stepnout;
tables csex cond clive livsp jobsp cmstat hs job drvlic majsup gangev gangc
painlf dprslf anxlf hallulf conclf viollf sidelf sattlf msdp1 tcutot 
arstlf minorch age1ar arstjv arstdrg livch supch fostch
parole_violation reincarc_9mo arrest_9mo;
run;

/*create some derived variables*/
data stepnout;
set stepnout;
if age >= 18 and age <=29 then agegroup = 1;
if age > 29 and age <=39 then agegroup = 2;
if age > 39 and age <=49 then agegroup = 3;
if age >49 and age<=59 then agegroup = 4;
if minorch GT 0 then hasminorchflg = 1; else hasminorchflg = 0;
if livch GT 0 then livchflg = 1; else livchflg = 0;
if supch GT 0 then supchflg = 1; else supchflg = 0;
if fostch GT 0 then fostchflg = 1; else fostchflg = 0;
if INH30D ^= 0 then inhlast30flg = 1; else inhlast30flg =0;
if MJ30D ^=0 then mjlast30flg = 1;else mjlast30flg =0;
if HLUC30D ^= 0 then hallulast30flg =1;else hallulast30flg =0;
if CRCK30D ^=0 then cracklast30flg = 1;else cracklast30flg =0;
if COC30D ^=0 then coclast30flg = 1;else coclast30flg =0;
if COINJ30 ^=0 then cocinjlast30flg = 1;else cocinklast30flg =0;
if HCOC30D ^=0 then hercoclast30flg = 1;else hercoclast30flg =0;
if HCINJ30 ^=0 then hercocinjlast30flg = 1;else hercocinjlast30flg =0;
if HMTH30D ^=0 then hermethlast30flg = 1;else hermethlast30flg =0;
if HMINJ30 ^=0 then hermethinjlast30flg = 1;else hermethinjlast30flg =0;
if HER30D ^=0 then herlast30flg = 1;else herlast30flg =0;
if HEINJ30 ^=0 then herinjlast30flg = 1;else herinjlast30flg =0;
if MTHD30D ^=0 then methlast30flg = 1;else methlast30flg =0;
if MTINJ30 ^=0 then methinjlast30flg = 1;else methinjlast30flg =0;
if OPIAT30D ^=0 then opiatelast30flg = 1;else opiatelast30flg =0;
if OPINJ30 ^=0 then opinjlast30flg = 1;else opinjlast30flg =0;
if META30D ^=0 then methalast30flg = 1;else methalast30flg =0;
if MEINJ30 ^=0 then meinjlast30flg = 1;else meinjlast30flg =0;
if AMPH30D ^=0 then amphlast30flg = 1;else amphlast30flg =0;
if AMINJ30 ^=0 then aminjlast30flg = 1;else aminjlast30flg =0;
if LIB30D ^=0 then liblast30flg = 1;else liblast30flg =0;
if LBINJ30 ^=0 then libinjlast30flg = 1;else libinjlast30flg =0;
if BARB30D ^=0 then barblast30flg = 1;else barblast30flg =0;
if SED30D ^=0 then sedlast30flg = 1;else sedlast30flg =0;
if SDINJ30 ^=0 then sdinjlast30flg = 1;else sdinjlast30flg =0;
if GHB30D ^=0 then ghblast30flg = 1;else ghblast30flg =0;
if GBINJ30 ^=0 then ghbinjlast30flg = 1;else ghbinjlast30flg =0;
if KET30D ^=0 then ketlast30flg = 1;else ketlast30flg =0;
if KETINJ30 ^=0 then ketinjlast30flg = 1;else ketinjlast30flg =0;
if OTHD30D ^=0 then othdlast30flg = 1;else othdlast30flg =0;
if OTHINJ30 ^=0 then othinjlast30flg = 1;else othinjlast30flg =0;
run;

proc standard data=stepnout out=stepnout mean=0 std=1;
var minorch tcutot arstjv arstlf arstdrg age1ar supch fostch livch;
run;

/*view whether there appears to be a difference in rate of parolees who report having minor
children based on gender*/
proc sort data = stepnout;
by csex;
run;

proc freq data = stepnout;
by csex;
tables hasminorchflg;
run;

/*view whether there appears to be a difference in the ages of parolees who have children
based on their gender*/
proc means data = stepnout N Mean Std Min Q1 Median Q3 Max;
ods output Summary=MeansSummary2;
where hasminorchflg = 1;
by csex;
var age;
run;


/*view whether there appears to be difference in various outcomes associated
with having children by gender*/
proc gchart data = stepnout; 
by csex; 
vbar hasminorchflg/discrete type=sum sumvar=parole_violation;
run;

proc gchart data = stepnout; 
by csex; 
vbar hasminorchflg/discrete type=sum sumvar=arrest_9mo;
run;

proc gchart data = stepnout; 
by csex; 
vbar hasminorchflg/discrete type=mean sumvar=reincarc_9mo;
run;

proc gchart data = stepnout; 
by csex; 
vbar hasminorchflg/discrete type=mean sumvar=drug_charge;
run;

/*test whether the outcomes difference for women with minor children vs. men
is statistically significant*/
PROC FREQ data = stepnout; TABLES parole_violation*hasminorchflg/CHISQ;
by csex;
RUN;

/*run Chi Square test*/
PROC FREQ data = stepnout; TABLES arrest_9mo*hasminorchflg/CHISQ;
by csex;
RUN;

/*run Chi Square test*/
PROC FREQ data = stepnout; TABLES reincarc_9mo*hasminorchflg/CHISQ;
by csex;
RUN;

/*run Chi Square test*/
PROC FREQ data = stepnout; TABLES drug_charge*hasminorchflg/CHISQ;
by csex;
RUN;


/*subset to only females & control for minor child*/
data stepnout_female;
set stepnout;
if csex = 2;
run;

proc standard data=stepnout_female out=stepnout_female mean=0 std=1;
var minorch tcutot arstjv arstlf arstdrg age1ar supch fostch livch;
run;

proc freq data = stepnout_female;
tables cond hasminorchflg agegroup job jobsp majsup msdp1
clive drvlic dprslf conclf anxlf livsp cmstat hs gangev gangc painlf
hallulf viollf sidelf sattlf livchflg supchflg fostchflg 
amphlast30flg sedlast30flg opiatelast30flg
inhlast30flg mjlast30flg hallulast30flg coclast30flg cracklast30flg
hercoclast30flg hermethlast30flg herlast30flg methlast30flg methalast30flg liblast30flg
barblast30flg ghblast30flg ketlast30flg othdlast30flg;
run;

/*removing gangev, gangc, fostchflg amphlast30flg, sedlast30flg inhlast30flg 
hallulast30flg, hercoclast30flg, hermethlast30flg methlast30flg methalast30flg liblast30flg
barblast30flg ghblast30flg ketlast30flg othdlast30flg and hallulf on the rule of 10*/

proc hpforest data=stepnout_female;
target arrest_9mo/level=nominal;
input cond hasminorchflg agegroup job jobsp majsup msdp1
clive drvlic dprslf conclf anxlf livsp cmstat hs painlf
viollf sidelf sattlf livchflg supchflg opiatelast30flg mjlast30flg
coclast30flg cracklast30flg herlast30flg/level=nominal;
input minorch tcutot LCSFSC1 arstjv livch fostch arstlf age1ar arstdrg/level=interval;
run;

/*first logistic model - kitchen sink*/
proc logistic descending data=stepnout_female; 
class job (ref='1') clive (ref='4') jobsp(ref='1') majsup (ref='1') msdp1 (ref='0');
model arrest_9mo = cond hasminorchflg agegroup job jobsp majsup msdp1
clive drvlic dprslf conclf anxlf livsp cmstat hs painlf
viollf sidelf sattlf livchflg supchflg opiatelast30flg mjlast30flg
coclast30flg cracklast30flg herlast30flg
minorch tcutot arstjv livch fostch arstlf age1ar arstdrg/;
run;

/*second logistic - top3 from the random forest*/
proc logistic descending data=stepnout_female; 
class job (ref='1');
model arrest_9mo = hasminorchflg job conclf/;
run;

/*test some of the multilevel categorical variables with
different contrasts individually*/
proc glm data=stepnout_female; 
class job (ref='1');
model arrest_9mo = job/solution;

proc glm data=stepnout_female; 
class clive (ref='4');
model arrest_9mo = clive/solution;

proc glm data=stepnout_female; 
class jobsp (ref='1');
model arrest_9mo = jobsp/solution;

proc glm data=stepnout_female; 
class majsup (ref='0');
model arrest_9mo =  majsup/solution;


/*collapse the job variable*/
data stepnout_female;
set stepnout_female;
if job = 1 then ftjobflg = 1; else ftjobflg = 0;
if opiatelast30flg = 1 or mjlast30flg = 1 or coclast30flg = 1
or cracklast30flg =1 or herlast30flg =1 then drglast30flg = 1;else drglast30flg =0;
run;


/*manually selected logistic model*/
proc logistic descending data=stepnout_female; 
model arrest_9mo = cond agegroup minorch ftjobflg
drvlic tcutot arstjv supch livch fostch hasminorchflg
dprslf conclf anxlf/;
run;

/*logistic with stepwise selection*/
proc logistic descending data=stepnout_female outest=betas covout;
class agegroup;
model arrest_9mo = agegroup ftjobflg drvlic 
dprslf conclf anxlf cmstat hs painlf
viollf sidelf sattlf livchflg supchflg fostchflg
minorch tcutot lcsfsc1 arstjv arstlf age1ar arstdrg 
drglast30flg hasminorchflg/
ctable 
selection=stepwise ridging=none maxiter=500 slentry=.15 slstay=.25 details lackfit rsquare;
 output out=pred p=phat lower=lcl upper=ucl 
             predprob=(individual crossvalidate);
run;

proc print data=betas;
      title2 'Parameter Estimates and Covariance Matrix';
   run;
   
proc print data=pred;
      title2 'Predicted Probabilities and 95% Confidence Limits';
   run;

data pred_female;
set pred;
keep cid phat _from_ _into_ arrest_9mo;
run;

proc sql;
select 
((a.TP + a.TN)/(a.TP + a.TN + a.FP + a.FN)) as Accuracy,
((a.TN)/(a.TN + a.FP)) as Specificity,
((a.TP)/(a.TP + a.FN)) as Sensitivity
from
(select 
sum(case when _from_ = '1' and _into_ = '1' then 1 else 0 end) as TP,
sum(case when _from_ = '0' and _into_ = '0' then 1 else 0 end) as TN,
sum(case when _from_ = '0' and _into_ = '1' then 1 else 0 end) as FP,
sum(case when _from_ = '1' and _into_ = '0' then 1 else 0 end) as FN
from pred_female) a;
quit;

/*tukey vs. pred*/
data arstdrg;
set mydata.stepnout;
if csex=2;
keep cid arstdrg;
run;

proc sql;
create table predtest as 
select t.*,p._into_ from arstdrg t
join pred_female p
on t.cid = p.cid;
quit;

/*proc univariate data=mydata.stepnout;
where csex=2;
var arstdrg;
run;*/

proc anova data=predtest;
where arstdrg <=10;
class _into_;
model arstdrg = _into_;
means _into_/tukey;
run;

/*tukey vs. actual*/
data lcsfsc3;
set mydata.stepnout;
if csex=2;
keep cid lcsfsc3;
run;

proc sql;
create table predtest as 
select t.*,p.arrest_9mo from lcsfsc3 t
join pred_female p
on t.cid = p.cid;
quit;

proc anova data=predtest;
class arrest_9mo;
model lcsfsc3 = arrest_9mo;
means arrest_9mo/tukey;
run;


/*subset to only females with minor children*/
data stepnout_female_minorch;
set stepnout;
if hasminorchflg = 1 and csex = 2;
run;

proc freq data = stepnout_female_minorch;
tables cond drvlic dprslf conclf anxlf ;
run;

proc means data = stepnout_female_minorch N Mean Std Min Q1 Median Q3 Max STACKODSOUTPUT; 
ods output Summary=MeansSummary; 
var tcutot arstjv livch fostch minorch age;
run;

proc standard data=stepnout_female_minorch out=stepnout_female_minorch_2 mean=0 std=1;
var minorch tcutot arstjv supch fostch livch;
run;

/*collapse the job variable*/
data stepnout_female_minorch;
set stepnout_female_minorch;
if job = 1 then ftjobflg = 1; else ftjobflg = 0;
run;

/*logistic with stepwise selection*/
proc logistic descending data=stepnout_female_minorch outest=betas covout;
class agegroup;
model arrest_9mo = agegroup ftjobflg drvlic 
dprslf conclf anxlf livsp cmstat hs painlf
viollf sidelf sattlf livchflg supchflg 
minorch tcutot arstjv livch arstlf age1ar arstdrg/
ctable
selection=stepwise ridging=none maxiter=500 slentry=.1 slstay=.15 details lackfit rsquare;
 output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
run;

proc print data=betas;
      title2 'Parameter Estimates and Covariance Matrix';
   run;
   
proc print data=pred;
      title2 'Predicted Probabilities and 95% Confidence Limits';
   run;
   
data pred_female_minorch;
set pred;
keep cid phat _from_ _into_ arrest_9mo;
run;

/*confusion matrix*/
proc sql;
select 
((a.TP + a.TN)/(a.TP + a.TN + a.FP + a.FN)) as Accuracy,
((a.TN)/(a.TN + a.FP)) as Specificity,
((a.TP)/(a.TP + a.FN)) as Sensitivity
from
(select 
sum(case when _from_ = '1' and _into_ = '1' then 1 else 0 end) as TP,
sum(case when _from_ = '0' and _into_ = '0' then 1 else 0 end) as TN,
sum(case when _from_ = '0' and _into_ = '1' then 1 else 0 end) as FP,
sum(case when _from_ = '1' and _into_ = '0' then 1 else 0 end) as FN
from pred_female_minorch) a;
quit;

data LCSFSC3;
set stepnout_female_minorch;
keep cid LCSFSC3;
run;

proc sql;
create table predtest as 
select t.*,p._into_ from LCSFSC3 t
join pred_female_minorch p
on t.cid = p.cid;
quit;

proc anova data=predtest;
class _into_;
model LCSFSC3 = _into_;
means _into_/tukey;
run;


/*collapse the job variable*/
data stepnout;
set stepnout;
if job = 1 then ftjobflg = 1; else ftjobflg = 0;
run;

/*logistic with stepwise selection*/
proc logistic descending data=stepnout outest=betas covout;
class agegroup (ref='1') csex;
model arrest_9mo = agegroup ftjobflg drvlic 
dprslf conclf anxlf livsp cmstat hs painlf
viollf sidelf sattlf livchflg supchflg 
minorch tcutot arstjv livch arstlf age1ar arstdrg
hasminorchflg csex/
ctable
selection=stepwise ridging=none maxiter=400 slentry=.1 slstay=.15 details lackfit rsquare;
 output out=pred p=phat lower=lcl upper=ucl
             predprob=(individual crossvalidate);
run;

proc print data=betas;
      title2 'Parameter Estimates and Covariance Matrix';
   run;
   
proc print data=pred;
      title2 'Predicted Probabilities and 95% Confidence Limits';
   run;
   
data pred_all;
set pred;
keep cid phat _from_ _into_ arrest_9mo;
run;

proc sql;
select 
((a.TP + a.TN)/(a.TP + a.TN + a.FP + a.FN)) as Accuracy,
((a.TN)/(a.TN + a.FP)) as Specificity,
((a.TP)/(a.TP + a.FN)) as Sensitivity
from
(select 
sum(case when _from_ = '1' and _into_ = '1' then 1 else 0 end) as TP,
sum(case when _from_ = '0' and _into_ = '0' then 1 else 0 end) as TN,
sum(case when _from_ = '0' and _into_ = '1' then 1 else 0 end) as FP,
sum(case when _from_ = '1' and _into_ = '0' then 1 else 0 end) as FN
from pred_all) a;
quit;

data LCSFSC3;
set stepnout;
keep cid LCSFSC3;
run;

proc sql;
create table predtest as 
select t.*,p._into_ from LCSFSC3 t
join pred_female_minorch p
on t.cid = p.cid;
quit;

proc anova data=predtest;
class _into_;
model LCSFSC3 = _into_;
means _into_/tukey;
run;


