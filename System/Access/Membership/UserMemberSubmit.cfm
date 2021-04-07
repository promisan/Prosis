
<cfoutput>

<cfparam name="URL.Mode" default="">
<cfparam name="URL.ID1" default="">
<cfparam name="URL.ID2" default="">
<cfparam name="Form.Member" default="#URL.ID1#">

<cfif Form.Member neq "">
	
	<cfloop index="group" list="#Form.Member#" delimiters=",">
	
			<cfparam name="URL.Mode" default="Dialog">
			
			<cfquery name="Check" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     SELECT *
					 FROM   UserNamesGroup
					 WHERE  Account      = '#URL.ACC#'
					 AND    AccountGroup = '#group#'
			</cfquery>
			
			<cfif Check.recordCount eq "1">
			    <script>
				   alert("You have selected a user who is already part of this group. Operation not allowed.")
				</script>
				
			<cfelse>	
									
				<cfquery name="Insert" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO UserNamesGroup 
				         (Account,
						 AccountGroup,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				      VALUES ('#URL.acc#',
				      	  '#group#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
				</cfquery>				
				
				<!--- logging --->
				
				<cfquery name="check" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   UserNamesGroupLog 
					 WHERE  Account       = '#url.acc#'
					 AND    AccountGroup  = '#group#' 
					 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
				</cfquery>
				
				<cfif check.recordcount eq "0">
				
					<cfquery name="InsertLog" 
					     datasource="AppsSystem" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO UserNamesGroupLog 
							 
						         (   Account,
									 AccountGroup,
									 DateEffective,
									 ActionStatus,
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName
								 )
								 
						      VALUES 
							  
							     ('#URL.acc#',
						      	  '#group#',
								  '#dateformat(now(),client.dateSQL)#',
								  '1',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
					</cfquery>		
				
				</cfif>	
								
				
				<!--- inherit all access of the group --->
				
				<!--- 2. inherit access for this user as granted to the group --->		
														
				<cfinvoke component= "Service.Access.AccessLog"  
					  method       = "SyncGroup"
					  UserGroup    = "#group#"
					  UserAccount  = "#URL.acc#"
					  Role         = "">	
				
				 				
			</cfif>	 
									 			  
							
	</cfloop>

</cfif>
	
<cfif URL.Mode eq "">

		<script>
			 more('#URL.ID1#','#url.id2#','enforce')
		</script>	
		
<cfelseif URL.Mode eq "new">		

	     <script>
			 window.close()
			 opener.history.go()
		</script>	
 
<cfelseif URL.Mode eq "Dialog">
  	
		<script>
			 window.close()
			 opener.history.go()
		</script>	
		
<cfelseif URL.Mode eq "workflow">
  	
		
<cfelse>		

		<script>
			#ajaxLink('#SESSION.root#/system/access/Membership/UserMemberList.cfm?id=#URL.acc#')#
		</script>

</cfif>	

</cfoutput>

