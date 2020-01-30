
 <!--- retrieve the last value --->
 
 <cfoutput>
 
 <cfparam name="url.serviceitem" default="">
			   
<cfquery name="GetDefault" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT FieldDefault
	  FROM   Ref_TopicServiceItem
	  WHERE  Code 		 = '#Code#'
	  AND    ServiceItem = '#url.ServiceItem#'
</cfquery>		
				
<cfquery name="GetValue" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
		SELECT TOP 1 *
		<cfif url.topicclass eq "WorkOrder">
		  FROM   WorkOrderLineTopic P
		<cfelse>
		  FROM   WorkOrderTopic P
		</cfif>					
		WHERE  Topic         = '#Code#'		
		AND    WorkOrderId   = '#URL.workorderid#'	
		<cfif url.topicclass eq "WorkOrder">  
		  AND    WorkOrderLine = '#url.workorderline#'		
		</cfif>	  
		
		ORDER BY DateEffective DESC				 		  
</cfquery>	
   
<cfif GetValue.TopicValue neq "">
	<cfset vDefault = GetValue.TopicValue>
<cfelseif GetDefault.FieldDefault neq "">
	<cfset vDefault = GetDefault.FieldDefault>
<cfelse>
	<cfset vDefault = GetDefault.FieldDefault>	
</cfif>		

<cfif ValueClass eq "List">
		   
	   <cfquery name="GetList" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT T.*, P.ListCode as Selected
			  FROM   Ref_TopicList T LEFT OUTER JOIN 
			         <cfif url.topicclass eq "WorkOrder">
					  WorkOrderLineTopic P
					<cfelse>
					  WorkOrderTopic P
					</cfif>		
					 ON P.Topic = T.Code  
			               AND    P.WorkOrderId   = '#URL.workorderid#'		
						   <cfif url.topicclass eq "WorkOrder">
						   AND    P.WorkOrderLine = '#url.workorderline#'									   
						   </cfif>
						   AND    P.DateEffective = (SELECT MAX(DateEffective)
						                             <cfif url.topicclass eq "WorkOrder">    
							                         FROM   WorkOrderLineTopic
													 <cfelse>
													 FROM   WorkOrderTopic
													 </cfif>
													 WHERE  WorkOrderId   = '#URL.workorderid#'		
													 <cfif url.topicclass eq "WorkOrder">   
													 AND    WorkOrderLine = '#url.workorderline#'
													 </cfif>
													 AND    Topic = T.Code	)
						   
						   
			  WHERE  T.Code = '#Code#'		
			  AND    T.Operational = 1		
			  ORDER BY T.ListOrder
		</cfquery>
						
		 <cfquery name="Def" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_TopicList
			  WHERE  Code = '#Code#'		
			  AND    ListDefault = 1		
		</cfquery>		
						
		<cfif getValue.ListCode neq "">
			<cfset def = getValue.ListCode>
		<cfelse>				    
			<cfset def = getValue.ListCode>				
		</cfif>		
																						   					   
	    <select name="Topic_#Code#" id="Topic_#Code#" class="#url.inputclass# enterastab">
		
			<cfif ValueObligatory eq "0">
			<option value=""></option>
			</cfif>		
			
			<cfloop query="GetList">					  
				<option value="#ListCode#" <cfif ListCode eq def>selected</cfif>>#ListValue#</option>
			</cfloop>
			
		</select>				
					
<cfelseif ValueClass eq "Lookup">
			
	   <cfquery name="GetList" 
		  datasource="#ListDataSource#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		 	  SELECT   DISTINCT 
			           #ListPK# as PK, 
			           #ListDisplay# as Display,
					   0 as DEF
			  FROM     #ListTable#
			  ORDER BY #ListDisplay#
		</cfquery>
																   					   
	    <select name="Topic_#Code#" id="Topic_#Code#" class="#url.inputclass# enterastab">
			<cfif ValueObligatory eq "0">
			<option value=""></option>
			</cfif>
			<cfloop query="GetList">
				<option value="#PK#" <cfif GetList.Display eq GetValue.TopicValue>selected</cfif>>#Display#</option>
			</cfloop>
		</select>						
												
<cfelseif ValueClass eq "Text">
													
		<cfif ValueObligatory eq "1">	
		
		<!-- <cfform> -->							
								
		<cfinput type="Text" name="Topic_#Code#" id="Topic_#Code#"
	       required="#ValueObligatory#"					     
	       size="#valueLength#"
		   style="padding-left:3px"
		   class="#url.inputclass# enterastab"
		   message="Please Enter a #Description#"
		   value="#GetValue.TopicValue#"
	       maxlength="#ValueLength#">
		   
		  <!-- </cfform> --> 
		   					   
		<cfelse>
		
		
		<input type="Text" name="Topic_#Code#" id="Topic_#Code#"				       			     
	       size="#valueLength#"
		   class="#url.inputclass# enterastab"					  
		   value="#GetValue.TopicValue#"
		   style="padding-left:3px"
	       maxlength="#ValueLength#">
		
		</cfif>
		
<cfelseif ValueClass eq "Memo">
	
		   <cf_textarea name="Topic_#Code#" id="Topic_#Code#"                                      
			   height         = "100" 
			   width          = "91%"
			   toolbar        = "basic"
			   init           = "Yes"
			   resize         = "yes"
			   color          = "ffffff">#GetValue.TopicValue#</cf_textarea>						   						
				   			   
<cfelseif ValueClass eq "Date">		
	
		<cfif ValueObligatory eq "1">
						
		<!-- <cfform> -->																			   				
		<cf_intelliCalendarDate9 class="#url.inputclass# enterastab"
			FieldName="Topic_#Code#" 
			Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
			Manual="False"
			AllowBlank="#ValueObligatory#">	
			<!-- </cfform> --> 
			
		<cfelse>					
																								   				
		<cf_intelliCalendarDate9 class="#url.inputclass# enterastab"
			FieldName="Topic_#Code#" 
			Manual="False"
			Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
			AllowBlank="Yes">	
								
		</cfif>	
								
						
<cfelseif ValueClass eq "Boolean">
				
		<input type="Checkbox" class="enterastab" style="height:16px;width:16px"
	       name="Topic_#Code#" 
                 id="Topic_#Code#"
		   <cfif vDefault eq "1">checked</cfif>
	       value="1">		   		   
	
</cfif>

</cfoutput>