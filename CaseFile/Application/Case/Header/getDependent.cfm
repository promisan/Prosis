
<cfparam name="url.personNo"      default="">
<cfparam name="url.dependentid"   default="">

<cfquery name="Dependent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonDependent
		WHERE  PersonNo = '#url.personNo#'
</cfquery>

<select name="DependentId">
	<option value="">[Same]</option>
	<cfoutput query="Dependent">
		<option value="#dependentid#" <cfif url.dependentid eq dependentid>selected</cfif>>#FirstName# #LastName# [#Gender#] #dateformat(BirthDate,CLIENT.DateFormatShow)#</option>
	</cfoutput>
</select>	


