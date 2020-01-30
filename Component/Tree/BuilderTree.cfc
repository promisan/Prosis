<cfcomponent>

<cfproperty name="BuilderTree" type="string" displayname="Builder Tree">
  
<cffunction name="getNodes" access="remote" returntype="array">

   <cfargument name="path"                type="String" required="false" default=""/>
   <cfargument name="value"               type="String" required="true" default=""/>
   <cfargument name="SystemFunctionId"    type="String" required="true" default=""/>
   <cfargument name="FunctionSerialNo"    type="String" required="true" default="1"/>
   <cfargument name="Box"                 type="String" required="true" default="1"/>
   
    <cfset var result= arrayNew(1)/>
    <cfset var s =""/>	 
       
    <!--- set up return array --->
       
	<cfif value eq "">
	  
	  		<cfquery name="MyFields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_ModuleControlDetailField
				WHERE SystemFunctionId = '#SystemFunctionId#'
				AND   FunctionSerialNo = '#FunctionSerialNo#'
				AND   FieldTree = 1
				ORDER BY ListingOrder
			</cfquery>
			
			<!--- first level --->
			
			<cfloop query="MyFields">
	  	  	   		
			    <cfset s = structNew()/>

	            <cfset s.value     = "#fieldname#">
				<cfset s.img       = ""> 
				<cfset s.parent    = "tree"> 
				
				<!---
				<cfset s.href      = "#template#?ID2=#mission#">
				<cfset s.target    = "right">
				--->
				
				<cfif fieldHeaderLabel neq "">
					<cfset s.display   = "<span style='font-size:18px;padding-top:3px;padding-bottom:3px;color: black;'>#fieldheaderlabel#">	
				<cfelse>
					<cfset s.display   = "<span style='font-size:18px;padding-top:3px;padding-bottom:3px;color: black;'>#fieldname#">	
				</cfif>		
				
				<cfif MyFields.recordcount eq "1">
				<cfset s.expand    = "true">
				<cfelse>
				<cfset s.expand    = "false">
				</cfif>
										
	            <cfset arrayAppend(result,s)/>
			
			</cfloop>
			
	  <cfelse>	
	  
	  	   <cfset fld = "">
		   <cfset sub = "">
		   	
	  	   <cfloop index="itm" list="#value#" delimiters=":">
		         <cfif fld eq "">
			   		<cfset fld = itm>
				 <cfelse>
				 	<cfset sub = itm>	
				 </cfif>		
		   </cfloop>	
	  
	       <cfquery name="Field" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_ModuleControlDetailField
				WHERE SystemFunctionId = '#SystemFunctionId#'
				AND   FunctionSerialNo = '#FunctionSerialNo#'
				AND   FieldName = '#fld#'				
			</cfquery>
	  
	  	  <!--- data level --->	
	  	  
		  <cfquery name="Listing" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ModuleControlDetail
				WHERE  SystemFunctionId = '#SystemFunctionId#'
				AND    FunctionSerialNo = '#FunctionSerialNo#'			
		  </cfquery>
			
		  <cfset sc = Listing.QueryScript>		   
		  		  			
		  <cftry>		
			
				<!--- if file exist do not run full preparation for the tree --->		
					
				<cfset fileNo = "#Listing.DetailSerialNo#">		
						 
			    <cfinclude template="../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">		
				<cfinclude template="../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">											
				
				<cftransaction isolation="READ_UNCOMMITTED">											
				<cfquery name="preset" 
					datasource="#Listing.QueryDatasource#">	
					    #preservesinglequotes(sc)#							
				</cfquery> 
				</cftransaction>	 						
										
				<cfcatch>
			
					<cfinclude template="../../System/Modules/InquiryBuilder/QueryPreparation.cfm">					
					<cfinclude template="../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">
					
					<cftransaction isolation="READ_UNCOMMITTED">										
					<cfquery name="preset" 
						datasource="#Listing.QueryDatasource#">	
						    #preservesinglequotes(sc)#							
					</cfquery>  	
					</cftransaction>	
							
				</cfcatch>
			
			</cftry>	   			  
						
			<cfif field.fieldaliasquery eq "">
				<cfset fldq = "#fld#">
			<cfelse>
			    <cfset fldq = "#field.fieldaliasquery#.#fld#"> 	
			</cfif>			
							  		  
			<cfquery name="data"        
	    	     dbtype="query">
				   SELECT   DISTINCT #fld# AS PK
				   FROM     preset					    
			</cfquery>			 
			 
			 <cfif fld eq "mission" or fld eq "entity">	
			 
				 	<cfif sub neq "">  
														
						<cfquery name="getMission" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   Mission 
							FROM     Ref_Mission
							WHERE    Mission IN (#quotedValueList(data.pk)#)
							AND      MissionType = '#sub#'						
						</cfquery> 		
						
						<cfoutput query="getMission">	
																																 			           
						        <cfset s = structNew()/>
						        <cfset s.value     = "#mission#">			
								<cfset s.img       = "">			
								<cfset s.parent    = "#fld#_#sub#"> 
								<cfset s.leafnode=true/>
								<cfset s.display   = "<span style='font-size:14px;padding-top:3px;padding-bottom:3px;color: black;'>#mission#">			
								<cfset s.href      = "javascript:filtertree('#fldq#','#mission#')">						
								<cfset s.expand    = "false">					
						        <cfset arrayAppend(result,s)/>	
																		
				       </cfoutput>
									
					<cfelse>
					
						<cfset s = structNew()/>
				         <cfset s.value     = "#fld#_000">			
						 <cfset s.img       = "">			
						 <cfset s.parent    = "#fld#"> 
						 <cfset s.leafnode=true/>
						 <cfset s.display   = "<span style='font-size:16px;font-weight:normal;padding-top:3px;padding-bottom:3px;color: black;'>all</span>">			
						 <cfset s.href      = "javascript:filtertree('undefined','undefined')">					
						 <cfset s.expand    = "false">					
				         <cfset arrayAppend(result,s)/>	
										
						<cfquery name="getMission" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   MissionType,Mission 
							FROM     Ref_Mission
							WHERE    Mission IN (#quotedValueList(data.pk)#)
							ORDER BY MissionType, Mission
						</cfquery>
						
						<cfoutput query="getMission" group="MissionType">								
						
								<cfset par = missionType>
								
								<cfset s = structNew()/>
							    <cfset s.value     = "#fld#:#par#">			
								<cfset s.img       = "">			
								<cfset s.parent    = "#fld#"> 
								<cfset s.leafnode=false/>
								<cfset s.display   = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px;color: black;'>#par#">														
								<cfset s.expand    = "false">					
							    <cfset arrayAppend(result,s)/>							
																				
						 </cfoutput>					 
					 
					 </cfif>				 								
			
			<cfelse>
				
				<cfset s = structNew()/>
				<cfset s.value     = "#fld#_000">   
				<cfset s.img       = "">   
				<cfset s.parent    = "#fld#"> 
				<cfset s.leafnode=true/>
				<cfset s.display   = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px;color: black;'>ALL">   
				<cfset s.href      = "javascript:filtertree('undefined','undefined')">     
				<cfset s.expand    = "false">     
				<cfset arrayAppend(result,s)/>
										  				   			           
		        <cfoutput query="data" maxrows=80>
						
					<cfif pk neq "">
					
						<cfif field.FieldOutputFormat eq "date">
						
							<cfset val = dateformat(pk,CLIENT.DateFormatShow)>
							<cfset fil = dateformat(pk,client.datesql)>
							
						<cfelse>
						
						    <cfset val = pk>	
							<cfset fil = pk>
						
						</cfif>
						
						<cfif len(val) gt 20>
							<cfset dis = "#left(val,20)#..">
						<cfelse>
							<cfset dis = val>	
						</cfif>
													 			           
			            <cfset s = structNew()/>
			            <cfset s.value     = "#fld#_#currentrow#">			
						<cfset s.img       = "">			
						<cfset s.parent    = "#fld#"> 
						<cfset s.leafnode=true/>
						<cfset s.display   = "<span style='font-size:14px;padding-top:3px;padding-bottom:3px;color: black;'>#dis#">			
						<cfset s.href      = "javascript:filtertree('#fldq#','#fil#')">						
						<cfset s.expand    = "false">					
			            <cfset arrayAppend(result,s)/>	
					
					</cfif>
							
		       </cfoutput>
			   
			 </cfif>
			 
					   
		   	   	   	   	   
	   </cfif>
		      
   <cfreturn result/>
</cffunction>

</cfcomponent>
