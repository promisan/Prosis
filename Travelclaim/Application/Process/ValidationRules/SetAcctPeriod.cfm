<cfsilent>
 <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for setting Accounting Period Only If Userquery.dbo.t_name has more than one row  </proDes>
 <proCom>New File  called from Validaiontrule_A02.cfm</proCom>
</cfsilent>
<!--- This I am getting the Min date effective date from StfundStatus table ---->
<cfquery name="temp1" datasource="appsTravelClaim" >
			SELECT   DISTINCT Fs.FundType, 
						st.Period, 
					 	min(Fs.DateEffective) as DateEffective
						into userquery.dbo.#t_name1#
						FROM     stFundStatus Fs,
							  Userquery.dbo.#t_name# st 
						WHERE    Fs.Period         = st.Period
						AND      Fs.FundType       = st.FundType
						Group By Fs.FundType,st.Period
					   
</cfquery>
<!---This I am inserting Default account to be as according to the current date as
well as converting dateeffective similar to accounting Period format ---->
<cfquery  name="temp2"  datasource="appsTravelClaim">
			SELECT     A.FundType,
			            A.period,
						isnull (A.DefaultAccount,'#default#') as DefaultAccount,
						B.DateEffective,
						convert(char(4) ,datepart(yy,B.DateEffective)) +'01.0' as t_mm
						into userquery.dbo.#t_name2#
					   From userquery.dbo.#t_name#  A, userquery.dbo.#t_name1#  B
					   where A.Fundtype = B.Fundtype
					   and   A.Period = B.Period
					   
					   
</cfquery>
<!---Getting the Max of effective date which is in the accounting period format ---->
<cfquery  name="temp3"  datasource="appsTravelClaim">
			SELECT  
			max(t_mm) as max_effectivedate 
			into userquery.dbo.#t_name3#
					   From userquery.dbo.#t_name2# 
					   
</cfquery>
<!--- converting the dateeffective field into a Integer and saving it into a my_diff which is 
the difference in the integer ---->
<cfquery  name="temp4"  datasource="appsTravelClaim">
	select fundtype,period,defaultaccount,
(convert(int,substring(B.max_effectivedate,1,6)) - convert(int,substring(A.defaultaccount,1,6))) as my_diff 
into userquery.dbo.#t_name4#

	from userquery.dbo.#t_name2# A, userquery.dbo.#t_name3# B
				   
</cfquery>

<cfquery name="setaccountingPeriod" datasource="appsTravelClaim">
select   top 1 *  from
userquery.dbo.#t_name4#    where my_diff = (select max (my_diff) from userquery.dbo.#t_name4# )

</cfquery>
<cfif setaccountingPeriod.recordcount gt 0 > 
	<cfset Valpap=setaccountingPeriod.defaultaccount>
</cfif>

