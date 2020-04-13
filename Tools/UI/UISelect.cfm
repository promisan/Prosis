<cfparam name="Attributes.Name"         default="true">
<cfparam name="Attributes.Display"    default="root">
<cfparam name="Attributes.Value"   default="">
<cfparam name="Attributes.ListDataSource" default="">
<cfparam name="Attributes.query"        type="query">
<cfparam name="Attributes.selected"    default="">
<cfparam name="Attributes.onchange"    default="">
<cfparam name="Attributes.group"        default="">
<cfparam name="attributes.style"        default="">
<cfparam name="attributes.filter"        default="">
<cfparam name="attributes.class"        default="">
<cfparam name="attributes.optionsLabel" default="15">
<cfparam name="attributes.multiple"     default="No">
<cfparam name="attributes.message"     default="">



<cfif thisTag.executionmode is 'start'>
    <cfoutput>

        <cfif attributes.multiple eq "No">
                <input id="_#Attributes.Name#" <cfif attributes.style neq "">style="#attributes.style#"</cfif> <cfif attributes.class neq "">class="#attributes.class#"</cfif>/>
                <input name="#Attributes.Name#"	id="#Attributes.Name#" 	type="hidden" value="#attributes.selected#" >
        <cfelse>
            <select
                id="_#attributes.name#"
                multiple="multiple"
                data-placeholder="#attributes.message#"
                <cfif attributes.style neq "">style="#attributes.style#"</cfif> <cfif attributes.class neq "">class="#attributes.class#"</cfif>>
                <cfloop query="attributes.query">
                    <cfset valueField = Evaluate("#Attributes.Value#")>
                    <cfset textField = Evaluate("#Attributes.Display#")>
                    <option value='#Replace(valueField,"'","\'","ALL")#'>#Replace(textField,"'","\'","ALL")#</option>
                </cfloop>
            </select>

            <cfset vSelected = "">
            <cfloop list="#attributes.selected#" index="element"><cfset vSelected = "#vSelected#,'#Replace(element,"'","","ALL")#'"></cfloop>

            <input name="#Attributes.Name#"	id="#Attributes.Name#" 	type="hidden" value="#attributes.selected#" >

        </cfif>

    </cfoutput>
<cfelseif thisTag.ExecutionMode is 'end'>

    <cfif attributes.multiple eq "No">
            <cfset vReturn = ParseHTMLTag(thisTag.GeneratedContent)>
            <cfset vValue = vReturn['Attributes']['value']>
            <cfset vDisplay = vReturn['Attributes']['Inside']>
            <cfoutput>
            <cfsavecontent variable="kDropDown">
                $("##_#Attributes.Name#").kendoDropDownList({
                dataSource: {
                data: [
                { #Attributes.Value#: '#vValue#', #Attributes.Display#: '#vDisplay#'<cfif attributes.group neq "">,#attributes.group#:''</cfif> },
                <cfloop query="attributes.query">
                    <cfset valueField = Evaluate("#Attributes.Value#")>
                    <cfset textField = Evaluate("#Attributes.Display#")>
                    <cfif Attributes.group neq "">
                        <cfset vGroup = Evaluate("#Attributes.group#")>
                    </cfif>
                    { #Attributes.Value#: '#Replace(valueField,"'","\'","ALL")#', #Attributes.Display#: '#Replace(textField,"'","\'","ALL")#' <cfif attributes.group neq "">,#attributes.group#:'#vGroup#'</cfif> },
                </cfloop>

                ],
                schema: {
                    model: { id: "#Attributes.Value#" }
                }
                <cfif attributes.group neq "">
                    ,group: { field: '#attributes.group#' }
                </cfif>
                },
                template:'<span style="font-size:#attributes.optionsLabel#px">##: data.#Attributes.Display# ##</span>',
                autoWidth: true,
                <cfif attributes.group neq "">
                    height: 400,
                </cfif>
                <cfif attributes.onchange neq "">
                    change: OnChange_#Attributes.name#,
                </cfif>
                dataValueField: "#Attributes.Value#",
                dataTextField: "#Attributes.Display#",
                <cfif attributes.selected neq "">
                    value :"#attributes.selected#",
                </cfif>
                <cfif attributes.filter neq "">
                    filter: "#attributes.filter#",
                </cfif>
                animation:false,
                select: function(e) {
                var item = e.dataItem;
                $('###Attributes.Name#').val(item.#Attributes.Value#);
                }
                });



                function OnChange_#Attributes.name#()
                {
                #attributes.onchange#
                }
            </cfsavecontent>

            <cfset AjaxOnLoad("function(){#kDropDown#}")>
            </cfoutput>

    <cfelse>
        <cfoutput>
            <cfsavecontent variable="kDropDown">
                $("##_#Attributes.Name#").kendoMultiSelect({
                        autoClose: false,
                        change: function(e) {
                            $("###Attributes.Name#").val(this.value());
                            console.log(this.value());
                        },
                        <cfif attributes.selected neq "">
                            value :[#vSelected#]
                        </cfif>
                    });



            </cfsavecontent>

            <cfset AjaxOnLoad("function(){#kDropDown#}")>
        </cfoutput>

    </cfif>



    <cfset thisTag.GeneratedContent = "">

</cfif>



<cffunction
        name="ParseHTMLTag"
        access="public"
        returntype="struct"
        output="false"
        hint="Parses the given HTML tag into a ColdFusion struct.">

<!--- Define arguments. --->
    <cfargument
            name="HTML"
            type="string"
            required="true"
            hint="The raw HTML for the tag."
            />

<!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />

<!--- Create a structure for the taget tag data. --->
    <cfset LOCAL.Tag = StructNew() />

<!--- Store the raw HTML into the tag. --->
    <cfset LOCAL.Tag.HTML = ARGUMENTS.HTML />

<!--- Set a default name. --->
    <cfset LOCAL.Tag.Name = "" />

<!---
    Create an structure for the attributes. Each
    attribute will be stored by it's name.
--->
    <cfset LOCAL.Tag.Attributes = StructNew() />


<!---
    Create a pattern to find the tag name. While it
    might seem overkill to create a pattern just to
    find the name, I find it easier than dealing with
    token / list delimiters.
--->
    <cfset LOCAL.NamePattern = CreateObject(
            "java",
            "java.util.regex.Pattern"
            ).Compile(
            "^<(\w+)"
            )
            />

<!--- Get the matcher for this pattern. --->
    <cfset LOCAL.NameMatcher = LOCAL.NamePattern.Matcher(
        ARGUMENTS.HTML
        ) />

<!---
    Check to see if we found the tag. We know there
    can only be ONE tag name, so using an IF statement
    rather than a conditional loop will help save us
    processing time.
--->
    <cfif LOCAL.NameMatcher.Find()>

<!--- Store the tag name in all upper case. --->
        <cfset LOCAL.Tag.Name = UCase(
            LOCAL.NameMatcher.Group( 1 )
            ) />

    </cfif>



<!---
    Now that we have a tag name, let's find the
    attributes of the tag. Remember, attributes may
    or may not have quotes around their values. Also,
    some attributes (while not XHTML compliant) might
    not even have a value associated with it (ex.
    disabled, readonly).
--->
    <cfset LOCAL.AttributePattern = CreateObject(
            "java",
            "java.util.regex.Pattern"
            ).Compile(
            "\s+(\w+)(?:\s*=\s*(""[^""]*""|[^\s>]*))?"
            )
            />

<!--- Get the matcher for the attribute pattern. --->
    <cfset LOCAL.AttributeMatcher = LOCAL.AttributePattern.Matcher(
        ARGUMENTS.HTML
        ) />


<!---
    Keep looping over the attributes while we
    have more to match.
--->
    <cfloop condition="LOCAL.AttributeMatcher.Find()">

<!--- Grab the attribute name. --->
        <cfset LOCAL.Name = LOCAL.AttributeMatcher.Group( JavaCast('int',1) ) />

<!---
    Create an entry for the attribute in our attributes
    structure. By default, just set it the empty string.
    For attributes that do not have a name, we are just
    going to have to store this empty string.
--->
        <cfset LOCAL.Tag.Attributes[ LOCAL.Name ] = "" />

<!---
    Get the attribute value. Save this into a scoped
    variable because this might return a NULL value
    (if the group in our name-value pattern failed
    to match).
--->
        <cfset LOCAL.Value = LOCAL.AttributeMatcher.Group( JavaCast('int',2) ) />

<!---
    Check to see if we still have the value. If the
    group failed to match then the above would have
    returned NULL and destroyed our variable.
--->
        <cfif StructKeyExists( LOCAL, "Value" )>

<!---
    We found the attribute. Now, just remove any
    leading or trailing quotes. This way, our values
    will be consistent if the tag used quoted or
    non-quoted attributes.
--->
            <cfset LOCAL.Value = LOCAL.Value.ReplaceAll(
                    "^""|""$",
                    ""
                    ) />

<!---
    Store the value into the attribute entry back
    into our attributes structure (overwriting the
    default empty string).
--->
            <cfset LOCAL.Tag.Attributes[ LOCAL.Name ] = LOCAL.Value />

        </cfif>

    </cfloop>


<!--- now we get the information inside the tag---->
    <cfset LOCAL.InsidePattern = CreateObject(
            "java",
            "java.util.regex.Pattern"
            ).Compile(
            "<\s*option[^>]*>(.*?)<\s*/\s*option>"
            )
            />

<!--- Get the matcher for this pattern. --->
    <cfset LOCAL.InsideMatcher = LOCAL.InsidePattern.Matcher(
        ARGUMENTS.HTML
        ) />


    <cfif LOCAL.InsideMatcher.Find()>

        <cfset LOCAL.Tag.Attributes['Inside'] =  LOCAL.InsideMatcher.Group(JavaCast('int',1) ) />

    </cfif>


<!--- Return the tag. --->
    <cfreturn LOCAL.Tag />
</cffunction>



