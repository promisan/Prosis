<cfcomponent>

    <cfparam name="SESSION.authent" default="0">
	
	<cfset VARIABLES.Instance.USR_MID = "_user" />
	<cfset VARIABLES.Instance.SES_MID = "_session" />

	<cffunction name="passtru" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="">
		<cfargument name="p1"    type="string" required="false" default="">
		<cfargument name="p2"    type="string" required="false" default="">		
		<cfargument name="p3"    type="string" required="false" default="">
			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.USR_MID, "SHA")>
				<cfset vLink       = "mid=#hash#">
				<cfreturn vLink>
			</cfif>
	</cffunction>	

	<cffunction name="setSrc" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="">
		<cfargument name="p1"    type="string" required="false" default="">
			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.USR_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "setSrc~#url##union#mid=#hash#~#p1#">
				<cfreturn vLink>
			<cfelse>
				<cfset vLink       = "setSrc~#url#~#p1#">
				<cfreturn vLink>
			</cfif>
	</cffunction>

	<cffunction name="submit" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"     type="string" required="false" default="">
		<cfargument name="target"  type="string" required="false" default="">
		<cfargument name="p1"      type="string" required="false" default="">
			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.SES_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "submit~#url##union#mid=#hash#~#target#~#p1#">
				<cfreturn vLink>
			<cfelse>
				<cfset vLink       = "submit~#url#~#target#~#p1#">
				<cfreturn vLink>
			</cfif>
	</cffunction>	
	
	<cffunction name="open" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="">
		<cfargument name="p1"    type="string" required="false" default="">
		<cfargument name="p2"    type="string" required="false" default="">		
		<cfargument name="p3"    type="string" required="false" default="">

			<cfif session.authent eq "1">
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.USR_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "open~#url##union#mid=#hash#~#p1#~#p2#~#p3#">
				<cfreturn vLink>
			<cfelse>
				<cfset vLink       = "open~#url#~#p1#~#p2#~#p3#">
				<cfreturn vLink>
			</cfif>
	</cffunction>

	<cffunction name="location" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="">
		<cfargument name="p1"    type="string" required="false" default="">
			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.USR_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "location~#url##union#mid=#hash#~#p1#">
				<cfreturn vLink>
			<cfelse>
				<cfset vLink       = "location~#url#~#p1#">
				<cfreturn vLink>
			</cfif>
	</cffunction>		

	<cffunction name="navigate" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="">
		<cfargument name="p1"    type="string" required="false" default="">				
		<cfargument name="p2"    type="string" required="false" default="">
		<cfargument name="p3"    type="string" required="false" default="">
		<cfargument name="p4"    type="string" required="false" default="">
		<cfargument name="p5"    type="string" required="false" default="">
			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.SES_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "navigate~#url##union#mid=#hash#~#p1#~#p2#~#p3#~#p4#~#p5#">
				<cfreturn vLink>
			<cfelse>
				<cfset vLink       = "navigate~#url#~#p1#~#p2#~#p3#~#p4#~#p5#">
				<cfreturn vLink>
			</cfif>
	</cffunction>		

	<cffunction name="submitForm" access="remote" returnFormat="json" output="false"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="p1"    type="string" required="false" default="" hint="This is the formname">				
		<cfargument name="url"   type="string" required="false" default="" hint="This is the URL">
		<cfargument name="p2"    type="string" required="false" default="" hint="This is the errer">
		<cfargument name="p3"    type="string" required="false" default="" hint="This is the URL">
		<cfargument name="p4"    type="string" required="false" default="POST" >
		<cfargument name="p5"    type="string" required="false" default="">

			<cfif SESSION.authent eq 1>
				<cfset hash        = Hash(getkey() & VARIABLES.Instance.SES_MID, "SHA")>
				<cfset union       = getUnion(url)>
				<cfset vLink       = "submitForm~#p1#~#url##union#mid=#hash#~#p2#~#p3#~#p4#~#p5#">
				<cfreturn vLink>
			</cfif>
	</cffunction>		
	
	<!--- DISCONTINUED
	<cffunction name="showModalDialog" access="remote" returnFormat="json" output="false">
		<cfargument name="url"   type="string" required="false" default="" hint="This is the URL">
		<cfargument name="p1"    type="any" required="false" default="" hint="usually null, represents the window name. Other possible values are _self, _blank, _parent">
		<cfargument name="p2"    type="string" required="false" default="" hint="Window attributes">
		<cfargument name="p3"    type="string" required="false" default="" hint="function after the return value is done">
		<cfargument name="p4"    type="any" required="false" default="" hint="function parametesr in the way of a json string">				
			<cfset hash        = Hash(getkey() & VARIABLES.Instance.SES_MID, "SHA")>
			<cfset vjson       = SerializeJSON(p4)>			
			<cfset union       = getUnion(url)>
			<cfset vLink       = "showModalDialog~#url##union#mid=#hash#~#p1#~#p2#~#p3#~#vjson#">
			<cfreturn vLink>			
	</cffunction>	
	--->	

	<cffunction name = "getUnion" access="remote" returnType="string"  secureJSON = "yes" verifyClient = "yes">
		<cfargument name="url"   type="string" required="false" default="" hint="This is the URL">	
		<cfif find("?",url) eq 0>
			<cfreturn "?">
		<cfelse>	
			 <cfreturn "&">				
		</cfif>
	</cffunction>	

	<cffunction name = "getKey" returnType="string">
		<cfif SESSION.authent eq 1>
			<cfset dateportion = DateFormat(now(),"DDMMYYYY")>
			<cfset timeportion = TimeFormat(now(),"hhmmss")>
			<cfset key         = SESSION.acc & getSecret() & dateportion & timeportion>
			<cfreturn key>
		</cfif>
	</cffunction>
	
	<cffunction name = "getSecret" returnType="string" secureJSON = "yes" verifyClient = "yes">

		<cfif SESSION.authent eq 1>
			<cfreturn "h@mesweeth@ome">
		</cfif>
	</cffunction>	
		
</cfcomponent>