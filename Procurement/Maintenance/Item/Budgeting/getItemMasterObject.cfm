
<cfparam name="url.selected"   default="">
<cfparam name="url.itemmaster" default="">

<cfquery name="ItemMasterObject" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT I.*
		  FROM   ItemMasterObject I
		  WHERE  ItemMaster = '#url.itemmaster#'
		  AND ObjectCode IN
		  	(
				SELECT  Code
				FROM    Program.dbo.Ref_Object
				WHERE   (ObjectUsage IN
			       	(SELECT     ObjectUsage
			            FROM      Program.dbo.Ref_AllotmentVersion V, Program.dbo.Ref_AllotmentEdition A
            			WHERE      V.Code = A.Version AND A.Mission = '#url.mission#'
					)
				)
				
			)
</cfquery>


<cfform>
	<cfif url.mode eq "edit" or url.mode eq "add">
	
		<cfselect name="RippleObjectCode" class="regularxl" style="width:100px"
			query="ItemMasterObject" 
			value="ObjectCode" 
			display="ObjectCode" 
			selected="#url.selected#"
			queryposition="below">
				
		</cfselect>	
	<cfelse>
		<cfoutput>
			#url.selected#
		</cfoutput>
	</cfif>		
	
</cfform>