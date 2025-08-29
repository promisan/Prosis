<!--
    Copyright © 2025 Promisan B.V.

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
<cfajaximport tags="CFDIV,CFWINDOW,CFFORM,CFINPUT-DATEFIELD,cftooltip">
<!-------------------------------------------------------------------- Modification  Details ----------------------------------
				Date: 		20/10/2008
				By: 		Huda Seid
				Detail:     Changed the vertical height: 300 to 330 and width:400 to 424 of the window to accommodate new text 
							added in ClaimEventEntryIndicatorEntryDialog.cfm
------------------------------------------------------------------------------------------------------------------------------------>
<cfoutput>

<script language="JavaScript1.2">

function currencyFormat(field,amount) {
	// created a comma seperated currency amount
	var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
	while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2');
	document.getElementById(field).value = amount
	}

function insertcost(title,mde,clm,per,ind,id2) {
   ColdFusion.Window.create('costings', 'Dialog', '',{x:100,y:100,height:330,width:425,modal:true,center:true})		
   ColdFusion.navigate('ClaimEventEntryIndicatorEntryDialog.cfm?title='+title+'&editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'costings')		

}

function deletecost(mde,clm,per,ind,id2) {
 ColdFusion.navigate('ClaimEventEntryIndicatorEntryCostDelete.cfm?editclaim='+mde+'&claimid='+clm+'&personno='+per+'&indicatorcode='+ind+'&id2='+id2,'b'+per+'_'+ind) 
}

</script>
	
	<table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="1" rules="rows">
	
	<cfif LinkRequest eq "1">
	
		<cfquery name="Lines" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT   I.Code as IndicatorCode,
		          Req.ClaimRequestLineNo, 
				  Req.PersonNo, 
				  P.LastName, 
				  P.FirstName, 
				  P.IndexNo,
				  P.Gender
		 FROM     Ref_Indicator I INNER JOIN
           	      Ref_ClaimCategoryIndicator CI ON I.Code = CI.IndicatorCode INNER JOIN
               	  ClaimRequestLine Req ON CI.ClaimCategory = Req.ClaimCategory INNER JOIN
               	  stPerson P ON Req.PersonNo = P.PersonNo
		 WHERE    I.Code = '#Code#' 
		 AND      Req.ClaimRequestId = '#Claim.ClaimRequestId#'		 	 
		 </cfquery>
		 
		<cfloop query="Lines">
		 
		 	<cfif claim.PersonNo neq PersonNo>
		    <tr bgcolor="DCF1EF">			    
			    <td colspan="5">Traveller: <font color="0066CC">#FirstName# #LastName# (#Gender#)</b></td>
			</tr>
			</cfif>				
			
			<tr bgcolor="ffffff">
			<td colspan="5">
			  <cfdiv bind="url:ClaimEventEntryIndicatorEntryCostRecord.cfm?editclaim=#editclaim#&claimid=#URL.ClaimID#&personNo=#PersonNo#&indicatorcode=#IndicatorCode#"
			  id="b#PersonNo#_#IndicatorCode#">
			
			</td>
			</tr>
						
		</cfloop>
	  
	<cfelse>
	
		<tr>
			<td colspan="5">	
			 <cfdiv bind="url:ClaimEventEntryIndicatorEntryCostRecord.cfm?editclaim=#editclaim#&claimid=#URL.ClaimID#&personNo=#Claim.PersonNo#&indicatorcode=#Code#"
			  id="b#Claim.PersonNo#_#Code#">
						
			</td>
		</tr>
		 
	</cfif>
			
	</table>
			
</cfoutput>


	