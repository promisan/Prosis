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
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
<script>

function editclause(po,cde,mde) {
   
    w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 155;
	window.open("POViewClauseEdit.cfm?Mode="+mde+"&PurchaseNo="+po+"&ClauseCode="+cde+"&ts="+new Date().getTime(), "_blank");

}

ie = document.all?1:0
ns4 = document.layers?1:0

function l(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
		 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight4";
	 	 
	 }else{
		
     itm.className = "regular";		
		 }
  }
  </script>
  
</cfoutput>  
	
<table width="97%" cellspacing="0" cellpadding="0" align="center">

    <cfif URL.Mode eq "Edit">
	
	<cfquery name="GroupAll" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		SELECT F.*, 
		       S.PurchaseNo as Selected
		FROM   PurchaseClause S RIGHT OUTER JOIN Ref_Clause F ON F.Code = S.ClauseCode AND   S.PurchaseNo = '#URL.ID1#'	
		WHERE  (F.Operational = 1 or S.PurchaseNo is not NULL)		 	
     </cfquery>
	 
	 <cfoutput query="GroupAll">
										
		<cfif CurrentRow MOD 2><TR class="line"></cfif>
				<td width="50%" class="regular">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfif Selected eq "">
					      <TR class="regular">
				<cfelse>  <TR class="highlight">
				</cfif>
			   	<TD width="5%"></TD>
			    <TD width="85%" style="padding:2px" class="labelit">#ClauseName#</font></TD>
				<td width="20">
				<cfif selected neq "">
				     <cf_img icon="edit" onClick="javascript:editclause('#URL.ID1#','#Code#')">					   	
				</cfif>
				</td>
				<td width="30" align="center">
				<cfif Selected eq "">
					<input type="checkbox" class="radiol" name="ClauseCode" id="ClauseCode" value="'#Code#'" onClick="l(this,this.checked)"></td>
				<cfelse>
					<input type="checkbox" class="radiol" name="ClauseCode" id="ClauseCode" value="'#Code#'" checked onClick="l(this,this.checked)"></td>
			    </cfif>
				</table>
				</td>
				<cfif GroupAll.recordCount eq "1">
  						<td width="50%"></td>
				</cfif>
    			<cfif CurrentRow MOD 2><cfelse></TR></cfif> 	
													
		</CFOUTPUT>	
	
	<cfelse>
	
		<cfquery name="Clause" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
    	    FROM      PurchaseClause Q 
			WHERE     Q.PurchaseNo = '#URL.ID1#'
		</cfquery> 
  	   			
		<cfoutput query="Clause">
			    
			    <tr>
				
					<td width="40" align="center">
					
					<img src="#SESSION.root#/Images/portal_max.jpg" alt="" 
					id="#ClauseCode#Exp" border="0" class="regular" 
					align="absmiddle" style="cursor: pointer;" height="11" width="11"
					onClick="more('#ClauseCode#','show')">
					
					<img src="#SESSION.root#/Images/portal_min.jpg" 
					id="#ClauseCode#Min" alt="" border="0"  height="11" width="11"
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="more('#ClauseCode#','hide')">
					
					</td>
					
		   		    <td colspan="1" class="labelmedium" width="70%" style="padding-left:5px;cursor: pointer;" onClick="more('#ClauseCode#','hide')">#ClauseName#</td>
					<td colspan="1" class="labelmedium" width="15%">&nbsp;#dateformat(created,CLIENT.DateFormatShow)#</td>
					
					<td colspan="1" align="right" height="20">
					
						<table cellspacing="0" cellpadding="0">
						
							<tr>
							
							<td style="padding-left:6px;padding-top:4px">
											   
							   <cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
							   
							       <cf_img icon="edit" onClick="editclause('#URL.ID1#','#ClauseCode#','view')">
								  
							   </cfif>
						   
						    </td>
							
							<td style="padding-right:6px;padding-left:2px;padding-top:2px">
						
							<cf_img icon="print" onClick="javascript:clause('#ClauseCode#')">    
							
							</td>
						   
						    </tr>
					   
					    </table>
					   
					</td>
					
		       	</tr>
										
				<tr>
				   <td colspan="4" class="hide" id="#ClauseCode#">
					   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
						   <tr><td colspan="2" height="1" class="line"></td></tr>
					       <tr>
						   <td colspan="2" id="cl#ClauseCode#" style="padding:4px">#ClauseText# </td>
						   </tr>
		        	   </table>
				   </td>
				</tr>	
				
				<cfif currentrow neq recordcount>
				<tr><td colspan="4" class="line"></td></tr>
				</cfif>
							
		</cfoutput>
		
	</cfif>	
						
</table>
