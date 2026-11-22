# DTA information release

Help a Massachusetts DTA client give a trusted person or organization permission to discuss and share information about their benefit cases. The interview prepares **Voluntary Consent to Release Information (VARI-OI)** for the client to print, sign, and send to DTA.

This is different from naming an authorized representative to sign applications or use benefits. The interview explains the difference and links to that existing interview. It does not send the form to DTA or grant DTA Connect provider-portal access.

## Interview

`docassemble.PermissionToAccessDTAClientInformation:permission_to_access_dta_client_information.yml`

The interview covers one client and one named person or organization per consent. Permission lasts one year unless the client revokes it. It collects either an Agency ID or the last four digits of the client's SSN, never a full SSN. Helpers may enter answers; the finished form is for the client to sign.

The output uses the language of the [official DTA VARI-OI form](https://www.mass.gov/lists/voluntary-consent-to-release-information), Rev. 9/2017, verified as currently distributed on November 22, 2026. Its layout uses headings and expanding paragraphs instead of fixed PDF fields. The original consent, revocation rights, one-year term, signing lines, and sending instructions are retained. DTA allows an equivalent signed written consent; see [MassLegalServices' current SNAP guidance](https://www.masslegalservices.org/content/08-can-i-give-someone-permission-talk-dta-about-my-snap-case).

## Why this improves on the blank PDF

- Explains what information-sharing permission does and distinguishes it from the broader authorized-representative role.
- Requires a case identifier and preserves leading zeros in a four-digit SSN.
- Lets users review and edit the client, identifier, and recipient before printing.
- Includes a full recipient address; long names and addresses expand instead of being cut off.
- Explains signing, delivery, and cancellation in plain language. Signature and date lines stay blank for the client.

## Publication metadata

The entrypoint includes a searchable title and description, use and signing limits, form title/number, jurisdiction, English language, estimated time, filing flags, authoritative sources, and matching `LIST_topics`/`tags`.

The LIST codes are the deepest supported terms for this cross-program consent: SNAP (`BE-02-01-00-00`), TANF/TAFDC (`BE-02-02-00-00`), state-funded cash assistance/EAEDC (`BE-02-05-00-00`). It is not an application, benefits appeal, FOIA request, or privacy lawsuit, so those narrower but unrelated categories are not used. Terms were checked against taxonomy.legal's live feed on November 22, 2026.

## Validation

Three ALKiln scenarios are in `data/sources/dta_consent.feature`:

1. An organization receives permission using an Agency ID, with no known phone number.
2. A trusted person receives permission using an SSN ending in zero-prefixed digits; invalid characters are rejected, and editing to an Agency ID updates the saved answers before the final download. The Python output tests separately check that the old SSN is omitted.
3. A user who wants an authorized representative is directed to that interview before entering personal information.

The output checks render the real Word template and check selected identifiers, blank signature/date lines, and long recipient names/addresses:

```sh
python -m unittest discover -s tests -p 'test_*.py'
```

Dependencies for these tests: `docxtpl`, `python-docx`, and `jinja2`.

Use the standard ALKiln runner and built-in ALKiln 5 steps. Follow the [official setup guide](https://assemblyline.suffolklitlab.org/docs/components/ALKiln/setup) and [AI-assisted testing guide](https://assemblyline.suffolklitlab.org/docs/automated_quality_checks/ai_testing). No repository-specific runner or framework overrides are needed.

The three browser scenarios check successful downloads, invalid SSN input, answer editing, the resulting case-ID variables, and scope exits. Each scenario downloads a filename only once, as required by ALKiln. Built-in PDF comparisons check the organization output and the output after changing an SSN to an Agency ID against reviewed synthetic-data baselines from the earlier local run. The baselines have no signing date, so they do not depend on the day tests run. The Python tests above retain direct real-template checks for leading-zero SSNs, excluding an inactive/stale SSN after selecting an Agency ID, and long recipient names/addresses.

Manual release checks remain: open the PDF downloaded after changing the identifier and confirm it contains the new Agency ID and no old SSN; compare client/recipient/address/signature lines; inspect the interview at a 390px viewport for horizontal overflow; and inspect the final PDF's tag structure and long-answer layout. A screenshot step alone is not an automated mobile-layout assertion. The prior 3-scenario/46-step local result used the now-removed custom harness; it is historical evidence, not a pass of the standard runner. The converted scenarios have been checked for defined steps with Cucumber dry-run; a fresh standard-runner execution remains needed.

`maturity: testing` is intentional until the release review is complete. Automated checks do not attest attorney approval.

## Credits

Original student interview: Trevor Mears, Suffolk University Law School. The publication revision uses the Massachusetts Department of Transitional Assistance's current voluntary-consent form. The earlier student interview used a 2016 MLRI permission form.

Independent review removed the broad government-records category to favor the three precise benefits topics. The live Image-10 destination covers SNAP, TAFDC, and EAEDC. MLRI’s [Appendix C sample consent](https://masslegalhelp.org/sites/default/files/2024-02/Appendix%20C_2024%20SNAP%20Guide.pdf) expressly covers SNAP or cash benefits and lasts 12 months unless the client states otherwise. An older DTA role-policy table describes broader cash-program authority under the same administrative role, referencing Image-10A. On November 22, 2026, the project owner reviewed this specific scope question and instructed: "yes, keep current consent and limits". The generated form therefore retains the current official consent wording and limits. This scoped decision resolves the cash-scope question; it is not blanket legal signoff or permission to publish.
