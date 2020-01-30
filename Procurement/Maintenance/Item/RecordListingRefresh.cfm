
<!--- ---------------------------------------- --->
<!--- template to refresh listing in ajax mode --->
<!--- ---------------------------------------- --->

<cfparam name="url.id1" default="">
<cfparam name="url.col" default="">

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  ItemMaster
	WHERE Code = '#url.id1#'	
</cfquery>
	
<cfoutput>
	
	<cfswitch expression="#URL.Col#">
	
		<cfcase value="code">
		    #get.Code#									
		</cfcase>
		
		<cfcase value="desc">
								
			<cfif get.recordcount eq "0">
			 <font color="FF0000">removed</font>
			<cfelse>
			  #get.Description#
			</cfif>
			
		</cfcase>	
		
		<!---
		
		<cfcase value="objc">
		
			<cfquery name="object"
			datasource="AppsPurchase"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT  O.*
				FROM    ItemMasterObject I, Program.dbo.Ref_Object O
				WHERE   I.Objectcode = O.Code
				AND     I.ItemMaster = '#url.id1#'					  
			</cfquery>	
			
			<cfif object.recordcount eq "1">	
			
				#Object.Code# #Object.Description#
				
			<cfelse>
			
				<table cellspacing="0" cellpadding="0">
				<cfloop query="Object">
				<tr><td>
				#Code# #Description#
				</td></tr>
				</cfloop>
				</table>
						
			</cfif>	
				
									
		</cfcase>	
		
		--->
		
		<cfcase value="clss">
		
			#get.EntryClass#
									
		</cfcase>	
		
		<cfcase value="oper">
		
			<cfif get.operational eq "1">Yes<cfelse>No</cfif>
									
		</cfcase>	
	
	</cfswitch>

</cfoutput>

<cf_compression>