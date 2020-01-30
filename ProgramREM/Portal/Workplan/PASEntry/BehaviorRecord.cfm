
<cfparam name="error" default="">

<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Parameter
</cfquery>

<cfquery name="Contract" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT *
  FROM   Contract
  WHERE  ContractId = '#URL.ContractId#'
</cfquery>

<cfquery name="OrgUnit" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT *
  FROM   Organization
  WHERE  OrgUnit = '#Contract.OrgUnit#'
</cfquery>

<cfquery name="Class" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_BehaviorClass
  WHERE   Code = '#URL.Class#' 
</cfquery>

<cfquery name="Priority" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Priority
	  WHERE  Operational = 1
</cfquery>

<cfif Class.BehaviorFilter eq "NONE">

	<cfquery name="Behavior" 
	 datasource="AppsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		  SELECT  Code,BehaviorName,ListingOrder
		  FROM    Ref_Behavior R
		  WHERE   Code NOT IN (SELECT BehaviorCode 
		                       FROM ContractBehavior 
							   WHERE ContractId = '#URL.ContractId#')		 
		  AND     BehaviorClass = '#URL.Class#'	
		  AND     Operational = 1	
		 ORDER BY ListingOrder, BehaviorName	
	</cfquery>

<cfelseif Class.BehaviorFilter eq "Unit">

	<cfquery name="Behavior" 
	 datasource="AppsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		  SELECT  DISTINCT Code, BehaviorName, ListingOrder
		  FROM    Ref_Behavior R, 
		          Ref_BehaviorUnit U
		  WHERE   Code NOT IN (SELECT BehaviorCode 
		                       FROM   ContractBehavior 
							   WHERE  ContractId = '#URL.ContractId#')
		  AND     BehaviorClass  = '#URL.Class#'		
		  AND	  R.Code         = U.BehaviorCode	 
		  AND     U.OrgUnitClass = '#OrgUnit.OrgUnitClass#'	
		  AND     R.Operational  = 1	
		 ORDER BY ListingOrder, BehaviorName	
		 
	</cfquery>
		

<cfelseif Class.BehaviorFilter eq "Function">
		
	<!--- auto pupulate groups --->
		
	<cfquery name="Insert" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT R.Code
	    FROM   Ref_BehaviorFunction F, Ref_Behavior R
		WHERE  FunctionNo      = '#Contract.FunctionNo#'	
		AND    F.BehaviorGroup = R.BehaviorGroup
		AND    R.Operational = 1	
		AND    R.BehaviorGroup IN (SELECT BehaviorGroup 
		                           FROM   Ref_Behavior 
								   WHERE  BehaviorClass = '#URL.Class#') 
	</cfquery>
		
	<cfloop query="Insert">
	
		<cfquery name="ContractBehavior" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   ContractBehavior
			WHERE  ContractId   = '#URL.ContractID#' 
			AND    BehaviorCode = '#Code#'	
		</cfquery>
	
		<cfif ContractBehavior.recordCount eq "0">
	
			<cfquery name="InsertCB" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ContractBehavior (ContractId,BehaviorCode,PriorityCode)
				Values ('#URL.Contractid#', '#Code#','P01')	
			</cfquery>
			
		</cfif>

	</cfloop>

	<cfquery name="Behavior" 
	 datasource="AppsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		  SELECT  DISTINCT Code, 
		                   BehaviorName, 
						   ListingOrder 
		  FROM    Ref_Behavior R, 
		          Ref_BehaviorFunction U
		  WHERE   Code NOT IN (SELECT BehaviorCode 
		                       FROM   ContractBehavior 
							   WHERE  ContractId = '#URL.ContractId#')
		  AND     BehaviorClass    = '#URL.Class#'		
		  AND	  R.BehaviorGroup  = U.BehaviorGroup	 
		  AND     U.FunctionNo     = '#Contract.FunctionNo#'	
		 ORDER BY ListingOrder, BehaviorName	
	</cfquery>	

</cfif>

<cfquery name="Detail" 
	 datasource="appsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT     C.*, R.*, P.Description as PriorityDescription
		 FROM       ContractBehavior C, 
		            Ref_Behavior R, 
				    Ref_Priority P 
		 WHERE      ContractId      = '#URL.ContractId#'
		 AND        C.BehaviorCode  = R.Code
		 AND        C.PriorityCode  = P.Code
		 AND        R.BehaviorClass = '#URL.Class#'
		 ORDER BY   R.ListingOrder, R.BehaviorName		
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="new">   
</cfif>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
    
  <tr>
    <td width="100%">
	
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		<!---	
	    <tr class="labelmedium line">
		   <td width="20"></td>
		   <td width="20"></td>
		   <td width="250"><cf_tl id="Evaluation Factor"></td>
		   <td width="200"><cf_tl id="Behavior"></td>
		   <td width="60"><cf_tl id="Priority" var="0"></td>
		   <td width="60">	
		  	   <cfif Parameter.HideTraining eq "0">			   
			       	<cf_interface cde="TrainingHeader"><cfoutput>#Name#</cfoutput>			   
			   </cfif>		   
		   </td>
		   <td width="10%"></td>
	    </TR>	
		--->		
		
				
					
		<cfoutput query="Detail">
								
		  <cfquery name="Training" 
			 datasource="AppsEPAS" 
			 maxrows=1
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   SELECT *
			   FROM   ContractTraining
			   WHERE  ContractId = '#URL.ContractId#'
			    AND   BehaviorCode = '#BehaviorCode#'
		 </cfquery>
		 
																							
		<cfif URL.ID2 eq BehaviorCode>
		
										
			<tr>
			<td></td>
			<td style="min-width:30px" width="30" align="center">#CurrentRow#</td>
			<td align="absmiddle">
			
			   <cfset cde = BehaviorCode>
			   			   
			    <input type="hidden" name="#URL.Class#_BehaviorCodeOld" id="#URL.Class#_BehaviorCodeOld" value="#BehaviorCode#">
								
				<select id="#URL.Class#_BehaviorCode" name="#URL.Class#_BehaviorCode" style="width:200px;text-align: center;" class="regularxl">
				
					<cfquery name="Check" 
						 datasource="AppsEPAS" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT  Code,BehaviorName,ListingOrder
						 FROM    Ref_Behavior R
						 WHERE   Code = '#CDE#'
					</cfquery>		
					<option value="#cde#" selected>#Check.BehaviorName#</option>
									 					
					<cfloop query="Behavior">
					
						  <option value="#Code#" <cfif "#cde#" eq "#Code#">selected</cfif>>#BehaviorName#</option>
																			      
					</cfloop>
					
				</select>
			
		     </td>
			
			<td align="absmiddle">
			
			    <input type="text" class="regularxl" 
				  id="#URL.Class#_BehaviorDescription" 
				  name="#URL.Class#_BehaviorDescription" 
				  value="#BehaviorDescription#" 
				  size="60" 
				  maxlength="200">
		 
			</td>
						
			<td align="absmiddle">
			
			        <cfif Priority.recordcount gt "1">
					
			        <cfset pri = PriorityCode>
					<select name="#URL.Class#_PriorityCode" class="regularxl"  id="#URL.Class#_PriorityCode">
						<cfloop query="Priority">
						      <option value="#Code#" <cfif "#pri#" eq "#Code#">selected</cfif>>
							  #Description#
							  </option>
						</cfloop>
					</select>
					
					<cfelse>
										
					<input type="hidden" name="#URL.Class#_PriorityCode" id="#URL.Class#_PriorityCode" value="#Priority.Code#">									
					
					</cfif>
			
			</td>
			
			<td align="middle">
			
			  <cfif Parameter.HideTraining eq "0">
			
			  <input type="checkbox" class="radiol" 
				       	 name="#URL.Class#_Training" id="#URL.Class#_Training" 
						 value="1" <cfif Training.Recordcount neq "0">checked</cfif>>
						 
			  <cfelse>
			  
			   <input type="hidden" id="#URL.Class#_Training" 
			         name="#URL.Class#_Training" 
					 value="0">	 			 
						 
			  </cfif>			 
						 
			</td>			 
															   
			<td align="center">
			<cf_tl id="Save" var="1">
			<input type="button" value="#lt_text#" class="button10g" onclick="add#URL.class#('#URL.ID2#')">
			</td>
			    
			</TR>	
							  					
		<cfelse>	
							
		    <cfif class.minentries eq "1" and class.maxentries eq "1">
		
						<!--- we hide the behavior as it is the same as the class --->
			
			<cfelse>
			
								
				<tr class="labelmedium" bgcolor="ffffff">
				   <td></td>
				   <td style="min-width:30px"  align="center">#CurrentRow#</td>
				   <td style="min-width:240px" height="18">#BehaviorName#</td>
				   <td style="width:100%" ><cfif BehaviorDescription eq "">----<cfelse>#BehaviorDescription#</cfif></td>
				   <td style="min-width:100px"><cfif Priority.recordcount gt "1">#PriorityDescription#</cfif></td>
				   <td style="min-width:30px"  align="center">
				   <cfif Training.recordcount neq "0">
				   <b><img src="#SESSION.root#/Images/request.gif" 
				   alt="" align="absmiddle" border="0"></b><cfelse></cfif>
				   </td>
				 		 			  
				   <td align="center" style="min-width:50px">
				   			   
				   	<table><tr>
					
					<cfinvoke component = "Service.Access"  
					   method           = "staffing" 
					   mission          = "#Contract.Mission#" 
					   orgunit          = "#Contract.OrgUnit#" 
					   returnvariable   = "accessStaffing">	 
				   
					   <cfif Contract.ActionStatus lte "1" or getAdministrator("*") eq "1">
					   
						    <td>
						 	<cf_img icon="edit"	onclick="edit#URL.class#('#BehaviorCode#')">
							</td>						
							<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" or URL.Class eq "Unit">
							<td style="padding-left:4px">	
							<cf_img icon="delete"	onclick="delete#URL.class#('#BehaviorCode#')">					   					  
							</td>
							</cfif>
						
						</cfif>
						
						</tr></table>
					
				   </td>
				   
			    </TR>	
			
			</cfif>
			
			<cfif BehaviorMemo neq "">
						
				<tr>
				<td></td>
				<td></td>
				<td class="labelit" colspan="2" valign="top" style="background-color:f4f4f4;border-radius:5px;padding:4px;padding-left:10px;border: 1px solid DCDCDC;"><font color="6688aa">#BehaviorMemo#</td>
				</tr>
			
			</cfif>
										
		</cfif>
						
		</cfoutput>
		
		<cfoutput>
					
		<cfif Behavior.recordcount gte "1">
																			
			<cfif URL.ID2 eq "new" and 
			     (Contract.ActionStatus lte "1" or getAdministrator("*") eq "1") and 
				 Behavior.recordcount gte "0" and
				 Detail.recordcount lt Class.MaxEntries>			 			
			
			   <tr>
			   <td height="6" colspan="7" align="center">
			   <b><font color="FF5555">
			   <cfif error neq "">
			   		<cf_interface cde="#error#">#Name#
			   </cfif></td></tr>
			   					
			   <tr>
				<td align="center" width="20"><!--- #Detail.recordcount+1# ---></td>
				<td colspan="4" style="padding-left:10px">
				<table width="90%" cellspacing="0" cellpadding="0" class="formspacing">
				<tr>
				
				<td class="labelmedium"><cf_tl id="Classification" var="0">:</td>
				<td>
				
				 <input type="hidden" name="#URL.Class#_BehaviorCodeOld" id="#URL.Class#_BehaviorCodeOld" value="">
				 
				 <select name="#URL.Class#_BehaviorCode" 
				         id="#URL.Class#_BehaviorCode" 
						 class="regularxl"
			             style="text-align: center;"
			             onChange="show#URL.class#(this.value)">
						 
						 <option value="" selected></option>					 
						 <cfloop query="Behavior">
					 	  <option value="#Code#">#BehaviorName#</option>
						 </cfloop>					
						 
				 </select>
				
			     </td>
				</tr>
				
				<tr> 			
				<td class="labelmedium"><cf_tl id="Description" var="0">:</td>			
				<td>
				
					<table cellspacing="0" cellpadding="0" class="formpadding">
					    
					    <tr><td>
					
					   <input type="Text" 
					        id="#URL.Class#_BehaviorDescription"
						    name="#URL.Class#_BehaviorDescription" 						
							class="regularxl"
							visible="Yes" 
							enabled="Yes" 
							size="80" 
							maxlength="200">
				 
				 	    </td>
						
						<cfif Priority.recordcount gt "1">
						
						<td style="padding-left:10px"><cf_tl id="Priority" var="0">:</td>						  
															
						<td>
								
								<select name="#URL.Class#_PriorityCode" id="#URL.Class#_PriorityCode" visible="Yes" class="regularxl" enabled="Yes" style="text-align: center;">							   
									<cfloop query="Priority">
									      <option value="#Code#">
										  #Description#
										  </option>
									</cfloop>							
								</select>
						
						</td>
						
						<cfelse>
						
						<input type="hidden" name="#URL.Class#_PriorityCode" id="#URL.Class#_PriorityCode"  value="#Priority.Code#">								
						
						</cfif>
						
						
						</tr>
					</table>
				
				  </td>
				
				</tr>
										
				<cfif Parameter.HideTraining eq "0">
				
					<tr>
					<td><cf_tl id="Training" var="0"></td>
					<td colspan="1" align="center"><input type="checkbox" class="radiol" name="#URL.Class#_Training" id="#URL.Class#_Training" value="1"></td></tr>
						 
				<cfelse>
					
					 <input type="hidden" name="#URL.Class#_Training" id="#URL.Class#_Training" value="0">	 
						 
				</cfif>			
				
				<tr>			
				<td></td>																   
				<td> 
				<cf_tl id="Add" var="1">			
				<input type="button" value="#lt_text#" style="width:70px" class="button10g" onclick="javascript:add#URL.class#('new')">
				</td>			    
				</tr>	
				
				</table>
				
				</td>
				</tr>
							
				<tr><td height="3"></td></tr>
				<tr id="#URL.Class#_row" class="hide">
					<td></td>
					<td bgcolor="ffffdf" id="#URL.Class#_desc" colspan="6" valign="top" style="border: 1px solid DCDCDC;"></td>
				</tr>
				<tr><td height="3"></td></tr>
																	
			</cfif>	
		
		</cfif>
		
		</cfoutput>
									
		</table>

	</td>
	</tr>
						
</table>	