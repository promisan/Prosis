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
<!--- Prosis template framework --->

<cfsilent>
<proUsr>oppbajg1</proUsr>
<proOwn>Joseph George</proOwn>
<proDes>Just to delete unwanted </proDes>
<proCom></proCom>
<proCM></proCM>
<proInfo></proInfo>
</cfsilent>





<!--- Query written so that the ClaimEventIndicatorcostline 
       Gets deleted for the case where for  a TVRQ  
	   initially which was changed to Hired /Taxi and a LTR line
	   was added under other expenses and finally , The Hired was changed
	   back to Air , and the other screeen no longer shows the LTR line 
	   but shows up in the summary screen since the amounts are there .
	   This procedure deletes the cost line tables and the supporting
	   tables where the enteries are there.
	   JG3 11/11/2009
--->

<cfquery name="QueryResultSelect" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	select Eventcode from claimeventtrip C,claimevent D  
			where D.claimid ='#URL.Claimid#'
        		and C.claimeventid =D.claimeventid and EventCode in ('Hired','Taxi')
</cfquery>

<cfquery name="QueryResultSelect2" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	select *   from dbo.ClaimEventIndicatorCostLine 
		where claimEventid in (select C.ClaimEventid from claimeventtrip C,claimevent D
  							where D.claimid = '#URL.Claimid#'
							and C.claimeventid =D.claimeventid ) 
		and Indicatorcode ='MLOCAL'
</cfquery>


<!--- JG if no records are found and records are found in ClaimEventIndicatorCostline
      table matching the condition  then we delete otherwise we simple skip the 
	  delete 
--->
	  
<cfif QueryResultSelect.recordcount eq "0" and QueryResultSelect2.recordcount gt "0" >
<cfquery name="QueryResultSelect2" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	delete  from dbo.ClaimEventIndicatorCostLine 
		where claimEventid in (select C.ClaimEventid from claimeventtrip C,claimevent D
  							where D.claimid = '#URL.Claimid#'
							and C.claimeventid =D.claimeventid ) 
		and Indicatorcode ='MLOCAL'
	
	delete from dbo.ClaimEventIndicatorCost 
		where claimEventid in (select C.ClaimEventid from claimeventtrip C,claimevent D
  								where D.claimid = '#URL.Claimid#'
								and C.claimeventid =D.claimeventid ) 
		and Indicatorcode ='MLOCAL'	
	delete from claimline 
		where claimcategory ='LTR'
		and claimid = '#URL.Claimid#'
	
	delete  from claimeventindicator where claimeventid in  (SELECT ClaimEventid
				    FROM ClaimEvent C
				    WHERE ClaimId = '#URL.Claimid#')
					 and Indicatorcode ='MLOCAL'
</cfquery>
</cfif>

