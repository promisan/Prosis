
<cfquery name="GetTopics" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Topic
	  WHERE  Operational = 1		
</cfquery>
  
<cfquery name="Clean" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PersonMedical
		WHERE PersonNo = '#URL.ID#'
</cfquery>

<cftransaction>
								
<cfloop query="getTopics">

	    <cfif ValueClass eq "List">
		
			<cfparam name="Form.Topic_#Code#" default="">			
 		        <cfset value  = Evaluate("Form.Topic_#Code#")>
															
			 <cfquery name="GetList" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  FROM Ref_TopicList T
					  WHERE T.Code = '#Code#'
					  AND   T.ListCode = '#value#'				  
			</cfquery>
						
			<cfif value neq "">
						
			<cfquery name="InsertTopics" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO PersonMedical
			 		 (PersonNo,Topic,ListCode,TopicValue)
			  VALUES ('#URL.Id#','#Code#','#value#','#getList.ListValue#')
			</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfif ValueClass eq "Boolean">
			
				<cfparam name="Form.Topic_#Code#" default="0">
				
			</cfif>
			
			<cfparam name="Form.Topic_#Code#" default="">			
							
 		        <cfset value  = Evaluate("Form.Topic_#Code#")>
			
			<cfif value neq "">
			
				<cfquery name="InsertTopics" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO PersonMedical
				 		 (PersonNo, Topic, TopicValue)
				  VALUES ('#URL.Id#','#Code#','#value#')
				</cfquery>	
			
			</cfif>
		
		</cfif>	
				
	</cfloop>		 
 
 </cftransaction>
