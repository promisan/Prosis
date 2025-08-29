<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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