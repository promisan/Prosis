<!--- roster action header --->

<cfparam name="Attributes.ActionStatus" default="1">
<cfparam name="Attributes.Date"         default="stamp">
<cfparam name="Attributes.Datasource"  default="AppsSelection">
<cfparam name="Attributes.ActionList" type="any" default="">

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
	<cfquery name="AssignNo" 
	datasource="#Attributes.Datasource#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Applicant.dbo.Parameter SET RosterActionNo = RosterActionNo+1
	</cfquery>
	
	<cfquery name="New" 
	datasource="#Attributes.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT TOP 1 RosterActionNo
	   FROM   Applicant.dbo.Parameter
	</cfquery>
		
	<CFSET Caller.RosterActionNo = new.RosterActionNo>
			
			
	   <cftry>
	
			<cfquery name="RosterAction" 
			datasource="#Attributes.Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Applicant.dbo.RosterAction 
			   (RosterActionNo, 
			   ActionCode, 
			   ActionSubmitted, 
			   NodeIP,
			   OfficerUserId, 
			   OfficerUserLastName, 
			   OfficerUserFirstName, 
			   ActionEffective, 
			   ActionStatus, 
			   ActionRemarks,
			   Created)
			VALUES 
			   ('#New.RosterActionNo#',
			   '#Attributes.ActionCode#', 
			    <cfif attributes.date eq "stamp">
			   getDate(),
			   <cfelse>
			   '#attributes.date#',
			   </cfif>
			   '#CGI.Remote_Addr#',
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#', 
			   #now()#, 
			   '#Attributes.ActionStatus#', 
			   '#Attributes.ActionRemarks#',
			   <cfif attributes.date eq "stamp">
			   getDate()
			   <cfelse>
			   '#attributes.date#'
			   </cfif>)
			</cfquery>
		
		
		<cfcatch>
			
				<cfoutput>
				
					 <cf_RosterActionNo 
					   ActionCode="#Attributes.ActionCode#"
		  			   ActionStatus="#Attributes.ActionStatus#" 
				       ActionRemarks="#Attributes.ActionRemarks#"> 		
				   
				</cfoutput>   
				
		</cfcatch>
		
		</cftry>
		
		
</cflock>

<cfif Attributes.ActionCode eq "PER">
	
	<cfset i = 0>
	
	<cfset ar = attributes.actionlist>
	
	<cfloop array="#ar#" index="itm">
	
		<cfset i = i+1>
			  
	  	<cfquery name="UpdateOld" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO  ApplicantAction
					   (PersonNo,
					    RosterActionNo, 
					    ActionField, 
						ActionFieldValue,
						ActionFieldEffective,
						ActionStatus)
				VALUES 
				   ('#Form.PersonNo#',
				    '#New.RosterActionNo#',
					'#ar[i][1]#',
					'#ar[i][2]#',
					<cfif attributes.date eq "stamp">
				    getDate(),
				    <cfelse>
				   '#attributes.date#',
				    </cfif>
					'9')
		 </cfquery> 	 
			
		 <cfquery name="UpdateNew" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO  ApplicantAction
					   (PersonNo,
					    RosterActionNo, 
					    ActionField, 
						ActionFieldValue,
						ActionFieldEffective,
						ActionStatus)
				VALUES 
				   ('#Form.PersonNo#',
				    '#New.RosterActionNo#',
					'#ar[i][1]#',
					'#ar[i][3]#',
					<cfif attributes.date eq "stamp">
				    getDate(),
				    <cfelse>
				    '#attributes.date#',
				    </cfif>
					'1')
			</cfquery> 	 
			
	</cfloop> 	

</cfif>