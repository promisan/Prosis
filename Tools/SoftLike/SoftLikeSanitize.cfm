<cfparam name="attributes.field"    default="">
<cfparam name="attributes.type"     default="">
<cfparam name="attributes.language" default="">

<!---
    1. trim
    2. lower
    3. replace " " for % (text only)

    SPANISH COMMON ORTHOGRAPHIC ERRORS:
    1. replace "ge" for "je"
    2. replace "gi" for "ji"
    3. replace "ce" for "se"
    4. replace "ci" for "si"
    5. replace "ke" for "que"
    6. replace "ki" for "qui"
    7. replace "qe" for "que"
    8. replace "qi" for "qui"
    9. replace "v" for "b"
    10. replace "ll" for "y"
    11. replace "sh" for "ch"
    12. replace "h" for ""
    13. replace "z" for "s"
    14. replace "np" for "mp"
    15. replace "nb" for "mb"
    16. replace "nv" for "mb"
    17. replace "rr" for "r"
    18. replace "ka" for "ca"
    19. replace "ko" for "co"
    20. replace "ku" for "cu"
--->

<cfset vField = attributes.field>
<cfset vReturn = "">

<cfif TRIM(LCASE(attributes.type)) eq "db">

    <cfset vBase = "LOWER(LTRIM(RTRIM(#vField#)))">

    <cfif TRIM(LCASE(attributes.language)) eq "ESP">
        <cfoutput>
            <cfsavecontent variable="vTemp">
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                REPLACE(
                    #vBase#, 
                'ge', 'je'),
                'gi', 'ji'),
                'ce', 'se'),
                'ci', 'si'),
                'ke', 'que'),
                'ki', 'qui'),
                'qe', 'que'),
                'qi', 'qui'),
                'v', 'b'),
                'll', 'y'),
                'sh', 'ch'),
                'h', ''),
                'z', 's'),
                'np', 'mp'),
                'nb', 'mb'),
                'nv', 'mb'),
                'rr', 'r'),
                'ka', 'ca'),
                'ko', 'co'),
                'ku', 'cu')
            </cfsavecontent>
        </cfoutput>

        <cfset vBase = vTemp>
    </cfif>

    <cfset vReturn = vBase>
	
</cfif>

<cfif TRIM(LCASE(attributes.type)) eq "text">

    <cfset vField = TRIM(vField)>
    <cfset vField = LCASE(vField)>
    <cfset vField = REPLACE(vField, " ", "%", "ALL")>

    <cfif TRIM(LCASE(attributes.language)) eq "ESP">
        <cfset vField = REPLACE(vField, "ge", "je", "ALL")>
        <cfset vField = REPLACE(vField, "gi", "ji", "ALL")>
        <cfset vField = REPLACE(vField, "ce", "se", "ALL")>
        <cfset vField = REPLACE(vField, "ci", "si", "ALL")>
        <cfset vField = REPLACE(vField, "ke", "que", "ALL")>
        <cfset vField = REPLACE(vField, "ki", "qui", "ALL")>
        <cfset vField = REPLACE(vField, "qe", "que", "ALL")>
        <cfset vField = REPLACE(vField, "qi", "qui", "ALL")>
        <cfset vField = REPLACE(vField, "v", "b", "ALL")>
        <cfset vField = REPLACE(vField, "ll", "y", "ALL")>
        <cfset vField = REPLACE(vField, "sh", "ch", "ALL")>
        <cfset vField = REPLACE(vField, "h", "", "ALL")>
        <cfset vField = REPLACE(vField, "z", "s", "ALL")>
        <cfset vField = REPLACE(vField, "np", "mp", "ALL")>
        <cfset vField = REPLACE(vField, "nb", "mb", "ALL")>
        <cfset vField = REPLACE(vField, "nv", "mb", "ALL")>
        <cfset vField = REPLACE(vField, "rr", "r", "ALL")>
        <cfset vField = REPLACE(vField, "ka", "ca", "ALL")>
        <cfset vField = REPLACE(vField, "ko", "co", "ALL")>
        <cfset vField = REPLACE(vField, "ku", "cu", "ALL")>
    </cfif>
    <cfset vReturn = vField>
	
</cfif>

<cfset CALLER.sanitized = vReturn>