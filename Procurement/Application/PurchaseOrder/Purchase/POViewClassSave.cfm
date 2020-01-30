<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cfparam name="URL.ID1" default="0">
<cfparam name="URL.Mode" default="View">

<!--- update entry --->

<cfquery name="PurchaseClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_PurchaseClass 
</cfquery>

<cfloop query="PurchaseClass">
	<cfset cl[currentrow] = Code>
</cfloop>

<cfset row = 0>

<cfloop index="amt" list="#url.amount#" delimiters=";"> 
	
	<cfset row = row+1>
	
	<cfset cls = cl[row]>
	
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   PurchaseLineClass 
		WHERE   RequisitionNo = '#URL.ID#' 
		AND     PurchaseClass = '#cls#'		
	</cfquery>
	
	<cfset a = replace(amt,',','',"all")>
	
	<cfif LSisNumeric(a)>
	
		<cfif Check.recordcount eq "1">
		
			<cfquery name="PurchaseClass" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE PurchaseLineClass  
				SET    AmountPurchase = '#a#'
				WHERE   RequisitionNo = '#URL.ID#'
				AND     PurchaseClass = '#cls#'
			</cfquery>
			
		<cfelse>
		
			<cfquery name="PurchaseClass" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO PurchaseLineClass 
				(RequisitionNo, PurchaseClass, AmountPurchase, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES
				('#URL.ID#',
				 '#cls#',
				 '#a#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
			</cfquery>
		
		</cfif>	
	
	</cfif>

</cfloop>

<!--- reload screen --->

<cfinclude template="POViewClass.cfm">
