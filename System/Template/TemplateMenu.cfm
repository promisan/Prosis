<cfquery name="Mast" 
			  datasource="AppsControl">
			      SELECT * FROM ParameterSite
				  WHERE ServerRole = 'QA'
			</cfquery>

<cf_ViewTopMenu background="Yellow" label="DEPLOYMENT SERVER: <b>#Mast.ApplicationServer# (Master)</b>"> 