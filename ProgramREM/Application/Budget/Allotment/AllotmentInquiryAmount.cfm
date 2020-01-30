
<!--- ------------------------------------------------- --->
<!--- template to trigger updates in the inquiry screen --->
<!--- ------------------------------------------------- --->

<!--- check layout --->

<cfparam name="url.scope" default="regular">
<cfparam name="url.execution" default="hide">

<cfquery name="Allotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramAllotment
		WHERE  ProgramCode = '#URL.ProgramCode#'
		AND    Period      = '#URL.period#'
		AND    EditionId   = '#URL.EditionId#' 
</cfquery>		

<cfquery name="EditionRecord" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_AllotmentEdition
		WHERE  EditionId = '#URL.EditionId#' 
</cfquery>		

<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version = V.Code
	AND      E.ControlEdit = 1	
	AND      E.Mission     = '#EditionRecord.Mission#'   	
	AND      E.Version     = '#EditionRecord.Version#' 
	AND      (E.Period is NULL 
	              or 
		      E.Period IN (SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateEffective >= (SELECT DateEffective 
						                            FROM   Ref_Period  
													WHERE  Period = '#URL.Period#')
						  )							
			 )
	
	ORDER BY E.ListingOrder, Period	
</cfquery>

<cfset no = check.recordcount>

<!--- object list --->

<cfset obj = "">

<cfloop index="itm" list="#url.objectcode#">

	<cfif obj eq "">
		<cfset obj = "'#itm#'">
	<cfelse>
		<cfset obj = "#obj#,'#itm#'"> 
	</cfif>  

</cfloop>	

<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    * 
		FROM      Ref_Object
		WHERE     (Code IN (#preservesingleQuotes(obj)#) OR Code= '#Allotment.SupportObjectCode#')
		ORDER BY  Resource,
		          ParentCode
</cfquery>

<!--- overall total update --->

<cfoutput>

	<script language="JavaScript">				
		ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=hea&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&execution=#url.execution#','#url.editionid#_cell')				
		if (document.getElementById('totalcell')) {
			ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=heatot&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&execution=#url.execution#','totalcell')	
		}			
	</script>	
	
</cfoutput>

<cfoutput query="Object" group="Resource">		

	<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   Ref_ParameterMissionResource
		  WHERE  Mission      = '#EditionRecord.Mission#'						 
		  AND    Resource     = '#Resource#'  
	</cfquery>
		
	<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#Check.Mission#'
	</cfquery>
	
	<cfif check.ceiling eq "1">
	
		<cfquery name="Ceiling" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  <cfif Parameter.BudgetAmountMode eq "0">amount<cfelse>amount/1000 as amount</cfif> 
		  FROM   ProgramAllotmentCeiling
		  WHERE  ProgramCode  = '#URL.ProgramCode#'
		  AND    Period       = '#URL.Period#'
		  AND    EditionId    = '#URL.EditionId#'
		  AND    Resource     = '#Resource#'  
		</cfquery>
		
		<script>
			<!--- ceiling coloring --->			
			_cf_loadingtexthtml='';	
			ptoken.navigate('AllotmentEntryCeiling.cfm?ajaxload=1&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&resource=#resource#&amount=#ceiling.amount#','result')
		</script>
		
	</cfif>	
		
	<script>					
	    if (document.getElementById('#url.editionid#_#resource#_cell')) {
			_cf_loadingtexthtml='';					
			ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=res&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&resource=#resource#&execution=#url.execution#','#url.editionid#_#resource#_cell')	
			if (document.getElementById('#resource#_tot')) {
				ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=restot&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&resource=#resource#&execution=#url.execution#','#resource#_tot')	
			}				
		}			
	</script>			

	<!--- resource update --->

	<cfoutput group="ParentCode">
		
	        <!--- -------------------- --->
			<!--- -parent code update- --->
			<!--- -------------------- --->
			
			<cfif ParentCode neq "">
			
				<script>
				    
					_cf_loadingtexthtml='';	
					ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=cell&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&objectcode=#parentcode#&execution=#url.execution#','#url.editionid#_#parentcode#_cell')	
					if (document.getElementById('#resource#_tot')) { 
					ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=celltot&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&objectcode=#parentcode#&execution=#url.execution#','#parentcode#_tot')	
					}
					
					<cfif url.scope neq "detail">
					try { document.getElementById('verify_#parentcode#_#URL.editionid#').click() } catch(e) {}
					</cfif>
					
				</script>	
				
				<cfset par = ParentCode>
				
			<cfelse>
			  
			    <cfset par = "">	
			
			</cfif>		
	
		<cfoutput>
					
				<!--- --------------------- --->		
				<!--- -object code update-- --->
				<!--- --------------------- --->				
																			
				<script language="JavaScript">
				
					se = document.getElementById('#url.editionid#_#code#<cfif Code eq Par>_1</cfif>_cell')
					if (se)	{
						ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=cell&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&objectcode=#code#&execution=#url.execution#','#url.editionid#_#code#<cfif Code eq Par>_1</cfif>_cell')	
						if (document.getElementById('#code#<cfif Code eq Par>_1</cfif>_tot')) {			
						ptoken.navigate('AllotmentInquiryAmountFill.cfm?ajaxload=1&mode=celltot&program=#url.programcode#&period=#url.period#&edition=#url.editionid#&objectcode=#code#&execution=#url.execution#','#code#<cfif Code eq Par>_1</cfif>_tot')	
						}
					}
					<cfif url.scope neq "detail">
					try { document.getElementById('verify_#code#_#URL.editionid#').click() } catch(e) {}
					</cfif>
					
				</script>	
								
												
		</cfoutput>				
		
	</cfoutput>

</cfoutput>		

<cfoutput>

<!---
<script>
_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>"; 
</script>
--->

</cfoutput>

