
<cfparam name="URL.Mode" default="Dialog">

<cfoutput>

<cf_assignId>

<cftransaction action="BEGIN">

	<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM System.dbo.UserNamesGroup
		 WHERE Account      = '#url.acc#'
		 AND   AccountGroup = '#URL.ID1#'
	</cfquery>

	<cfquery name="check" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   System.dbo.UserNamesGroupLog 
		 WHERE  Account      = '#url.acc#'
		 AND    AccountGroup = '#URL.ID1#'
		 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
	</cfquery>
				
	<cfif check.recordcount eq "1">
	
		<cfquery name="set" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 UPDATE System.dbo.UserNamesGroupLog 
			 SET    ActionStatus = '9'
			 WHERE  Account      = '#url.acc#'
			 AND    AccountGroup = '#URL.ID1#'
			 AND    DateEffective = '#dateformat(now(),client.dateSQL)#'
	    </cfquery>
	
	<cfelse>
				
		<cfquery name="InsertLog" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 
			     INSERT INTO System.dbo.UserNamesGroupLog 
				 
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
			      	  '#URL.ID1#',
					  '#dateformat(now(),client.dateSQL)#',
					  '9',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>		
				
	</cfif>	

<cfoutput>
	<cfsavecontent variable="condition">
		 UserAccount = '#url.acc#'
		 AND   Source = '#URL.ID1#'
	</cfsavecontent>
</cfoutput>

<cfinvoke component="Service.Access.AccessLog"  
		  method="DeleteAccess"
		  ActionId             = "#rowguid#"
		  ActionStep           = "1"
		  ActionStatus         = "9"
		  UserAccount          = "#url.acc#"
		  Condition            = "#condition#"
		  DeleteCondition      = ""
		  AddDeny              = "0"
		  AddDenyCondition     = "">	 

</cftransaction>

<cfparam name="url.mid" default="">

<cfif URL.Mode neq "Dialog">

	<script>
	    Prosis.busy('no')	
		_cf_loadingtexthtml='';	
	  	#ajaxLink('#SESSION.root#/System/Access/Membership/UserMemberList.cfm?id=#URL.acc#&mid=#url.mid#')#
	</script>

<cfelse>

	<script>
		Prosis.busy('no')	
		_cf_loadingtexthtml='';	
		#ajaxLink('#SESSION.root#/System/Access/Membership/RecordListingDetail.cfm?row=#url.row#&mod=#URL.id1#&mid=#url.mid#')#		
	</script>	

</cfif>

 </cfoutput> 