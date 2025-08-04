<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
	<cfsilent>
	 <proUsr>Joseph George</proUsr>
	  <proOwn>Joseph George</proOwn>
	 <proDes>Template for validation Rule A01  </proDes>
	 <proCom>New File For Validation A01 </proCom>
	</cfsilent>
	
		<!--- 
		Validation Rule :  A01
		Name			:  Unable to Determine the Status of Claim Funding ( Records in Stclaimfunding exists which are not there 
						 :  in the reference table stfundstatus )
		Steps			:  If th  StfundStatus table no record defining the status os atleast one of NOn IOV based 
						:  fscl and fund type linking it with stfund table  which is portal specific.
		Date			:  15 July 2007
		Last date		:  16 July 2007
		--->
<!---
This is place I am getting all the Fund, Fscl information along with fund_cycl_num and iov_ind
if fund_cycl_num is equal 2 it is Biennium fund , and iov_ind =1 ( Iov) and if the even year 
treat it diffrently , in other words add one year to fscl year and call fund validations.
added on 03-11-2008 JG3 
--->		
<cfset code = "#code#" >
<cfquery name="fsclfundmain" 
datasource="appsTravelClaim"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT 
				 Fs.f_fnlp_fscl_yr AS F_Fscl, 
				 Fs.f_fund_id_code AS F_Fund,
				 Fs.fundtype as F_Fundtype,
				 Fs.iov_ind  as F_Iov_ind,
				 Fs.Fund_Cycl_num as F_Fund_Cycl_num 
		FROM     stClaimFunding Fs
		WHERE    Fs.ClaimRequestId = '#Claim.ClaimRequestId#' 
		and      AmountTotal >0 
		

</cfquery>
<cfloop query ="fsclfundmain">
<!----
<cfoutput> teate F_Iov_ind is #F_Iov_ind#  F_Fund_Cycl_num #F_Fund_Cycl_num# F_Fscl #F_Fscl# </cfoutput> 
 ---->
<cfif ( (F_Iov_ind eq 0 ) and (F_Fund_Cycl_num neq  2 ) and ((F_Fscl Mod 2 ) eq 1 )) >   
				<cfoutput> teate</cfoutput> 
		<cfquery name="Check" 
		datasource="appsTravelClaim"
		username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		SELECT DISTINCT 
				 st.f_fnlp_fscl_yr AS Fscl, 
				 st.f_fund_id_code AS Fund, 
				 Fs.Fundtype as FundType,
				 Fs.DateEffective,count(*) as my_count
		FROM     stFundStatus Fs,
				 stClaimFunding st 
		WHERE    st.ClaimRequestId = '#Claim.ClaimRequestId#'
		 AND     st.iov_ind  = '0'
		 AND     Fs.Period   =* st.f_fnlp_fscl_yr
		 AND     Fs.FundType =* st.FundType
		GROUP BY st.f_fnlp_fscl_yr, 
				 st.f_fund_id_code, 
				 FS.Fundtype,
				 Fs.DateEffective
		HAVING   Fs.DateEffective IS NULL  
		</cfquery>		 
		
			<cfif Check.recordcount neq 0>
			<cfset ValFundStatus = "closed">
			<cfset ValPap="NULL">
			<cfset msg    = "">
		
		
		
			<!--- ALERT : fund validation Cannot be performed since this condition with an 
						outer join should only result in zero rows , but it has returned 
						some rows from stclaimfunding table which are not there in stfundstatus  table --->
			
			
			<cfloop query="Check">
				<cfif msg eq "">
					<cfset msg = "#currentRow#. #fund#-#fscl# ">
				<cfelse>
					<cfset msg = "#msg#,#currentRow#. #fund#-#fscl# ">
				</cfif>	
			</cfloop>
				
			 <cf_ValidationInsert
				ClaimId        = "#URL.ClaimId#"
				ClaimLineNo    = ""
				CalculationId  = "#rowguid#"
				ValidationCode = "#code#"
				ValidationMemo = "#Description# #msg#"
				Mission        = "#ClaimRequest.Mission#">
					
		</cfif>
	</cfif>	
</cfloop>
<cfset msg ="">
<!--- This is place I just get the Fscl Fund if there are multiple BACs --->

<cfset description ="#description#">
<!--- If records are found go through a loop and find whether you have records in stfundstatus table 
       if NOT insert into A01 validation JG3 --->
<cfif fsclfundmain.recordcount neq 0 >
<cfloop query ="fsclfundmain">
<cfif (((F_Fscl Mod 2) eq 0) and (F_Fund_Cycl_num eq 2) and (F_Iov_ind eq 1) )>
<cfset FF_Fscl = #F_Fscl# +1>
<cfelse>
<cfset FF_Fscl = #F_Fscl# >
</cfif> 
<cfquery name="fscyfundwithindate" 
datasource="appsTravelClaim"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
select Fs.Fundtype as Fundtype,
       Fs.DateEffective 
	   FROM     stFundStatus Fs
	   WHERE 
					Fs.Period = '#FF_Fscl#'
					and Fs.Fundtype = '#F_Fundtype#'
				and Fs.dateeffective <= (SELECT max(TT.dateeffective) 
					FROM  stfundstatus TT
					WHERE 
					TT.Period = '#FF_Fscl#'
					and TT.Fundtype = '#F_Fundtype#'
				and TT.dateeffective <= getdate())
AND      getdate()  <= (SELECT max(TT1.dateeffective) 
			FROM  stfundstatus TT1
			WHERE 
			TT1.Period = '#FF_Fscl#'
			AND TT1.Fundtype = '#F_Fundtype#')		
<cfset msg = "#F_fund#-#FF_Fscl# ">
</cfquery>

<cfif fscyfundwithindate.recordcount eq 0>
<!---
<cfoutput> code is #code# desc#Description# #msg#  claim #URL.ClaimId# rowguid #rowguid# missio #ClaimRequest.Mission# </cfoutput>
--->

	 <cf_ValidationInsert
				ClaimId        = "#URL.ClaimId#"
				ClaimLineNo    = ""
				CalculationId  = "#rowguid#"
				ValidationCode = "#code#"
				ValidationMemo = "#Description# #msg#"
				Mission        = "#ClaimRequest.Mission#">
</cfif>

  
</cfloop>

</cfif>
