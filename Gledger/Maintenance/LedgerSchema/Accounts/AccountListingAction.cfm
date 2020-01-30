
<cftry>

<cfif url.toggle eq "1">

	<cfquery name="Insert"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_AccountMission 
		(Mission,GLAccount,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
		('#URL.mis#','#URL.Acc#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>

<cfelse>

	<cfquery name="Delete"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_AccountMission 
		WHERE  Mission = '#URL.mis#' 
		AND    GLAccount = '#URL.Acc#'
	</cfquery>

</cfif>

	<cfcatch></cfcatch>
	
</cftry>

<cfquery name="Mission"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT GLAccount 
		FROM   Ref_AccountMission 
		WHERE  Mission = '#URL.mis#' 
		AND    GLAccount = '#URL.Acc#'
</cfquery>

<cfoutput>

<cfif mission.recordcount eq "1">
			 
	 <img src="#SESSION.root#/Images/light_green1.gif"
	    border="0" 
		width="13" 
		height="13"
		alt="de-activate" 
	    align="absmiddle"
		style="cursor: pointer;" 
		onClick="accounttoggle('#URL.mis#','#url.acc#','0')">
		 
<cfelse>
			 
	 <img src="#SESSION.root#/Images/light_red1.gif"
	    border="0" alt="activate account" 
		width="13" 
		height="13"
	    align="absmiddle"
		style="cursor: pointer;" 
		onClick="accounttoggle('#URL.mis#','#url.acc#','1')">
			
</cfif>	

</cfoutput>