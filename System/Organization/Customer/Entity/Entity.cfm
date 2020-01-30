
<!--- entities to create --->

<cfquery name="Mission"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  *, (SELECT TOP 1 PersonNo 
	            FROM   Customer 
				WHERE  Mission = P.Mission
				AND    PersonNo = '#url.id#') as PersonNo
				
    FROM    Ref_ParameterMission P
	
	WHERE   Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Ref_MissionModule 
					    WHERE  SystemModule = 'WorkOrder')	
						
</cfquery>


<table width="90%" align="center">

<tr><td colspan="2" class="labellarge" style="font-size:22px;height:40px">Instantiate a customer profile record for the below entities:</td></tr>
	
	<cfoutput query="Mission">
				
		<cfinvoke component = "Service.Access"  
		   method           = "WorkorderManager" 
		   mission          = "#mission#"    <!--- check for the create option --->
		   returnvariable   = "access">	
		   
		<cfif Access eq "NONE" or access eq "READ">   
		
			<!--- it not then check if the person is a processor --->
		
			<cfinvoke component = "Service.Access"  
			   method           = "WorkorderProcessor" 
			   mission          = "#mission#" 		   
			   returnvariable   = "access">	   
		   
		</cfif>   
		
		<cfif access eq "EDIT" or access eq "ALL">
	
		<tr class="linedotted">
		   <td width="80%" style="padding-left:10px" class="labelmedium">#Mission#</td>
		   
		   <cfif PersonNo eq "">
		   
		   <td id="box#currentrow#" width="20%">
			   <input type="checkbox" 
			       class="radiol" 
				   name="selected" 
				   value="#Mission#" 
				   onclick="ColdFusion.navigate('#session.root#/System/Organization/Customer/Entity/EntitySubmit.cfm?personno=#url.id#&mission=#mission#','box#currentrow#')">
				   
		   </td>
		   <cfelse>
		   <td width="20%"  class="labelmedium">
		    <img src="#session.root#/images/checkmark.png" alt="" border="0">
		  		   
		   </td>
		   </cfif>
		   
	    </tr>
	   
	    </cfif>
		
	</cfoutput>	

</table>