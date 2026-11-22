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

The LIST codes are the deepest supported terms for this cross-program consent: SNAP (`BE-02-01-00-00`), TANF/TAFDC (`BE-02-02-00-00`), state-funded cash assistance/EAEDC (`BE-02-05-00-00`), and access to government records (`GO-02-00-00-00`). It is not an application, benefits appeal, FOIA request, or privacy lawsuit, so those narrower but unrelated categories are not used. Terms were checked against taxonomy.legal's live feed on November 22, 2026.

## Validation

Three ALKiln scenarios are in `data/sources/dta_consent.feature`:

1. An organization receives permission using an Agency ID, with no known phone number.
2. A trusted person receives permission using an SSN ending in zero-prefixed digits; invalid characters are rejected, and editing to an Agency ID removes the old SSN from the regenerated output.
3. A user who wants an authorized representative is directed to that interview before entering personal information.

The output checks render the real Word template and check selected identifiers, blank signature/date lines, and long recipient names/addresses:

```sh
python -m unittest discover -s tests -p 'test_*.py'
```

Dependencies for these tests: `docxtpl`, `python-docx`, and `jinja2`.

For a package already installed on a development server, `tests/run_alkiln.py` uses the `localhost` entry in `~/.docassemblecli` and an ALKiln checkout at `~/ALKiln` (or `ALKILN_PATH`). It keeps credentials out of generated files. Install this package on the test server first, then run:

```sh
python tests/run_alkiln.py
```

The browser suite downloads and examines generated PDFs; it requires `pdftotext`. Artifacts are ignored by Git under `.alkiln-artifacts/`. The local compatibility helpers recognize review screens that reuse their URL, retry read-only navigation probes when a page reload destroys a browser context, and remove a previously downloaded copy before checking regenerated output. The phone-width check excludes only the development server's injected debug paragraph.

`maturity: testing` is intentional until the release review is complete. Automated checks do not attest attorney approval.

## Credits

Original student interview: Trevor Mears, Suffolk University Law School. The publication revision uses the Massachusetts Department of Transitional Assistance's current voluntary-consent form. The earlier student interview used a 2016 MLRI permission form.
