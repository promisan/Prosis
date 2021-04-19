
<cfparam name="url.workorderid"   default="8B6A925C-1018-0668-4397-7C889F59FE61">

<cfoutput>
	
	<script>
	
	function calculate() {
	  ptoken.navigate('ServiceEditAmount.cfm?workorderid=#url.workorderid#','calculate','',',','POST','agreementform')
	}
	
	</script>

</cfoutput>

<cfif url.transactionid eq "">
  <cfset url.transactionid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="workorder" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrder
  WHERE  WorkOrderId = '#URL.workorderId#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Mission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrderBaseLine
  WHERE  TransactionId = '#URL.TransactionId#'
</cfquery>

<cfquery name="GetObject" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   OrganizationObject
  WHERE  ObjectKeyValue4 = '#URL.TransactionId#'
</cfquery>
		
<cfquery name="WrkClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   DISTINCT R.*
	FROM     Ref_EntityClassPublish P, Ref_EntityClass R
	WHERE    R.EntityCode  = 'WrkAgreement'
	AND      P.EntityCode  = R.EntityCode
	AND      P.EntityClass = R.EntityClass
	
	AND     
         (
		 
          R.EntityClass IN (SELECT EntityClass 
                            FROM   Ref_EntityClassOwner 
						    WHERE  EntityCode = 'WrkAgreement'
						    AND    EntityClass = R.EntityClass
						    AND    EntityClassOwner = '#Mission.MissionOwner#')
						   
		 OR
		
		  R.EntityClass NOT IN (SELECT EntityClass 
                                FROM   Ref_EntityClassOwner 
						        WHERE  EntityCode = 'WrkAgreement'
						        AND    EntityClass = R.EntityClass)							   
		 )			
		
</cfquery>

<cfquery name="unitlist" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

  SELECT *
  FROM   ServiceItemUnit
  WHERE  ServiceItem = '#workorder.serviceitem#'
  AND    BaseLineMode = 1
  <cfif get.recordcount eq "0"> 
  AND    Operational = 1
  <cfelse>
  AND    (
         Operational = 1 
         OR
         Unit IN (SELECT ServiceItemUnit 
                  FROM   WorkOrderBaseLineDetail 
				  WHERE  TransactionId = '#URL.TransactionId#')
		 )
				  
  </cfif>  
  ORDER BY ListingOrder
</cfquery>

<cf_screentop label  = "Service Agreement" 
              title  = "Service Level Agreement"              
			  html   = "No"
			  banner = "gray" 			  	
			  jquery = "Yes"
			  scroll = "Yes"
			  close  = "parent.ColdFusion.Window.destroy('mydialog',true)"		  
			  layout = "webapp">

<cfform action="ServiceEditSubmit.cfm?workorderid=#url.workorderid#&tabno=#url.tabno#" name="agreementform" method="POST" target="process">

<table width="700" class="formpadding formspacing" align="center">

    <tr class="hide">
	   <td colspan="2"><iframe name="process" id="process" width="100%" height="100"></iframe></td>
	</tr>
	
    <tr><td height="4"></td></tr>

    <cfif get.recordcount eq "0">
			
		<cf_assignid>							
		<cfoutput>
		<input type="hidden" name="TransactionId" id="TransactionId" value="#rowguid#">
		</cfoutput>
		<cfset url.transactionid = rowguid>
				
	<cfelse>
	    <cfoutput>
		<input type="hidden" name="TransactionId" id="TransactionId" value="#url.transactionid#">
		</cfoutput>
	
	</cfif>			
	
	<tr><td heifght="4"></td></tr>
	
	<tr>
	
		<td class="labelmedium"><cf_tl id="SLA Number">:</td>	 
	    <td>				   
	  		 <cfinput type="text" 
	         name="TransactionReference" 
			 size="1" 							 								
			 class="regularxl" 
			 style="width:200" 
			 maxLength="20"
			 visible="Yes" 
			 value="#get.TransactionReference#"
			 enabled="Yes">	
		 </td>		 
	</tr>	
	
	<cf_calendarscript>
	
	<tr>
	
	  <td class="labelmedium"><cf_tl id="Effective">:</td>			   
	   <td>			  				   
				   					   				
		    <cf_intelliCalendarDate9
			FieldName="DateEffective" 					
			Default="#Dateformat(get.dateEffective, CLIENT.DateFormatShow)#"	
			class="regularxl"	
			AllowBlank="False">	
				
	   </td>
	  </tr> 
	  
	  <tr>
	
	  <td class="labelmedium"><cf_tl id="Expiration">:</td>			   
	   <td>			  				   
				   					   				
		    <cf_intelliCalendarDate9
			FieldName="DateExpiration" 					
			Default="#Dateformat(get.dateExpiration, CLIENT.DateFormatShow)#"	
			class="regularxl"	
			AllowBlank="False">	
				
	   </td>
	  </tr> 
	  
	  <tr>
	
	  <td class="labelmedium"><cf_tl id="Approval flow">:<cf_space spaces="40"></td>			   
	  <td>			 
	  	  	  
		<cfif WrkClass.recordcount gte "1">
		
		    <select name="EntityClass" id="EntityClass" class="regularxl">
			    <cfoutput query="WrkClass">
					<option value="#EntityClass#" <cfif getObject.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
				</cfoutput>
		    </select>
			
		<cfelse>	
						
			<font size="1" color="FF0000"><cf_tl id="Workflow not configured"></font>	
				
		</cfif>	
		
		</td>
		
	</tr>		
	
	<tr>
			  		  
	  <td colspan="2" style="padding-top:5px">
	  
	  <table width="100%" cellspacing="0" cellpadding="0" class="formspacing">
	  
	  <tr class="hide"><td colspan="4" id="calculate"></td></tr>
	  
	  <tr>
	     <td class="labelmedium"><cf_tl id="Service Unit"></td>
		 <td class="labelmedium" align="right"><cf_tl id="Quantity"></td>
		 <td class="labelmedium" align="right"><cf_tl id="Rate"></td>
		 <td class="labelmedium" align="right"><cf_tl id="Amount"></td>
	  </tr>
	  		 	
	  <cfset total = 0>	  
		  
	  <cfoutput query="UnitList">
	  
	  <cfquery name="GetUnit" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  
	      SELECT *
          FROM   WorkOrderBaseLineDetail 
		  WHERE  TransactionId   = '#URL.TransactionId#'
		  AND    ServiceItem     = '#workorder.serviceitem#'
		  AND    ServiceItemUnit = '#unit#'
		 
	  </cfquery>

	  <tr >
	  
	     <td style="width:51%" class="labelmedium">#UnitDescription#</td>
		 <td class="labelit" align="right">
		 
			 <cfif getUnit.Quantity eq "">
			   <cfset qty = "0">
			 <cfelse>
			   <cfset qty = getUnit.Quantity>  		 
			 </cfif>
			 
			 <cfinput type="Text"
			     name     = "#unit#_qty" 
				 validate = "float" 
				 value    = "#qty#"
				 message  = "Invalid Quantity"
				 style    = "text-align:right;padding-right:2px"
				 size     = "10"
				 class    = "regularxl"
				 onchange = "calculate()"
				 required = "Yes" 
				 visible  = "Yes">
		 
		 </td>
		 
		 <td class="labelmedium" align="right">
		 
			 <cfif getUnit.Rate eq "">
			 
			       <!--- retrieve from rate table --->
				
				  <cfquery name="GetStandard" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT   SUM(M.StandardCost) AS StandardCost
					FROM     ServiceItemUnitMission AS M INNER JOIN
	                	     ServiceItemUnit AS U ON M.ServiceItem = U.ServiceItem AND M.ServiceItemUnit = U.Unit
					WHERE    M.Mission = '#workorder.mission#' 
					AND      U.UnitParent = '#unit#' 
					<!--- to be reviewed --->
					AND      M.DateEffective <= GETDATE() 
					AND      M.DateExpiration >= GETDATE()
				  </cfquery>
				  
				  <cfif getStandard.StandardCost eq "">
				      <cfset rte = "0"> 
				  <cfelse>
			 	      <cfset rte = "#GetStandard.StandardCost#">
				  </cfif>	  
			   
			 <cfelse>
			 
			   <cfset rte = getUnit.Rate>  		 
			   <CFSET total = total+getunit.amount>
			   
			 </cfif>		 
			 
			 <cfinput type="Text"
			     name     = "#unit#_rte" 
				 validate = "float" 
				 size     = "12"
				 message  = "Invalid Rate"
				 onchange = "calculate()"
				 class    = "regularxl"
				 style    = "text-align:right;padding-right:2px"
				 value    = "#rte#"
				 required = "Yes" 
				 visible  = "Yes">
		 			 
		 </td>
		 
		 <td class="labelmedium" id="#unit#_total" align="right" width="150">				 
			 #numberformat(getunit.amount,",.__")#	 		 
		 </td>
	  </tr>	 
	 	  	    
	  </cfoutput>	  
	  
	  <cfoutput>
	 
		  <tr><td class="labelmedium" colspan="3" align="right"></td>
		      <td class="labelmedium" height="24" align="right" id="total" style="border-top:1px solid silver">#numberformat(totaL,",.__")#</td>	  
		  </tr>
	  
	  </cfoutput>
	
	 </table>
	 
	  </td>
	  </tr>
	  	  
	  <tr><td class="labelmedium"><cf_tl id="Memo">:</td>
	      <td class="labelmedium">
			 <cfinput type="text" 
			         name="TransactionMemo" 
					 size="1" 							 								
					 class="regularxl" 
					 style="width:99%" 
					 MaxLength="150"
					 visible="Yes" 
					 VALUE="#get.TransactionMemo#"
					 enabled="Yes">
				
		  </td>		
	  </tr>
	  	   
	  <tr>	
				
   		<td class="labelmedium"><cf_tl id="Attachment"></td>
        <td>		
			
			
	   		<cf_filelibraryN
		    	DocumentHost="#parameter.documenthost#"
				DocumentPath="#parameter.documentLibrary#"
				SubDirectory="#url.workorderid#" 
				Box="box_0"
				Filter="#left(url.transactionid,8)#"						
				Insert="yes"
				Remove="yes"
				reload="true">		
							  
        </td>

     </tr>	
	 
	 <tr><td></td></tr>		  
		
	 <tr><td colspan="3" class="line"></td></tr>
	 
	<cfif WrkClass.recordcount gte "1">
		
	 <tr><td colspan="2" align="center" height="30">
	 	  <cfoutput>
		  	 <cf_tl id="Save" var="vSave">
			 
		     <input type="submit" id="save" name="save" value="#vSave#" class="button10g" style="width:120px">
		 </cfoutput>
		 </td>
	 </tr>
	 
	 </cfif>
	  
</table>
	
</cfform>

<cf_screenbottom layout="webapp">