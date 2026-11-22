"""Regression checks against the actual Word template, including dormant ID values.

Run with: python -m unittest discover -s tests -p 'test_*.py'
Requires python-docx, docxtpl and jinja2.
"""
from pathlib import Path
import tempfile
import unittest
from docx import Document
from docxtpl import DocxTemplate
from jinja2 import Environment, StrictUndefined

TEMPLATE = Path(__file__).resolve().parents[1] / 'docassemble/PermissionToAccessDTAClientInformation/data/templates/dta_voluntary_consent.docx'

class ConsentOutputTests(unittest.TestCase):
    def render(self, **changes):
        context = {
            'client_name': 'Lee Example',
            'client_birthdate': '03/04/1975',
            'dta_identifier_kind': 'ssn',
            'ssn_last_four': '0123',
            'recipient_name': 'Jordan Example',
            'recipient_phone': '',
            'recipient_address': '200 Example Road, Springfield, MA 01103',
            'format_date': lambda value, **kwargs: value,
        }
        context.update(changes)
        doc = DocxTemplate(TEMPLATE)
        doc.render(context, jinja_env=Environment(undefined=StrictUndefined))
        with tempfile.TemporaryDirectory() as tmp:
            path=Path(tmp)/'consent.docx'; doc.save(path)
            result=Document(path)
            return '\n'.join(p.text for p in result.paragraphs)

    def test_ssn_keeps_leading_zero_without_requiring_agency_id(self):
        text=self.render()
        self.assertIn('SSN: 0123',text)
        self.assertIn('Jordan Example',text)
        self.assertIn('Client/Applicant Signature: _____',text)
        self.assertIn('Date: _____',text)
        self.assertNotIn('None',text)

    def test_editing_to_agency_id_does_not_disclose_old_ssn(self):
        text=self.render(dta_identifier_kind='agency',dta_agency_id=' 987654321 ')
        self.assertIn('SSN: 987654321',text)
        self.assertNotIn('0123',text)

    def test_long_recipient_and_multiline_address_are_not_truncated(self):
        name='Example Community Benefits and Food Assistance Partnership for Families'
        address='100 Example Street, Building 2, Suite 450\nAttention: Community Benefits Team\nBoston, Massachusetts 02110'
        text=self.render(dta_identifier_kind='agency',dta_agency_id='123456789',recipient_name=name,recipient_address=address)
        self.assertIn(name,text)
        self.assertIn(address,text)
        self.assertIn('valid for one year',text)
        self.assertIn('1-877-382-2363',text)

if __name__=='__main__':
    unittest.main()
