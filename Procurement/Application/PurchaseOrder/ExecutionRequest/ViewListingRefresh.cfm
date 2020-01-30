
<!--- ---------------------------------------- --->
<!--- template to refresh listing in ajax mode --->
<!--- ---------------------------------------- --->

<cfparam name="url.requestid" default="">
<cfparam name="url.col" default="">

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#session.login#" 
password="#session.dbpw#">
	SELECT *
	FROM PurchaseExecutionRequest
	WHERE RequestId= '#URL.RequestId#'
</cfquery>

<cfoutput>
	
	<cfswitch expression="#URL.Col#">
	
		<cfcase value="des">
			
			<cfif Get.recordcount eq "0">
			     <font color="FF0000">Removed</font>
			<cfelse>
				   #get.RequestDescription#
			</cfif>	   
					
		</cfcase>
		
		<cfcase value="ref">
		
			<cfif Get.recordcount neq "0">
			#get.Reference#
			</cfif>
			
		</cfcase>
		
		<cfcase value="amt">
		
			<cfif Get.recordcount neq "0">
			#numberformat(get.RequestAmount,"__,__.__")#
			</cfif>
			
		</cfcase>
	
	</cfswitch>

</cfoutput>