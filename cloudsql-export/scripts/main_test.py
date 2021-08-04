import unittest

from freezegun import freeze_time
from main import get_export_object_uri

class Test(unittest.TestCase):

    @freeze_time("2012-01-01")
    def test_with_suffix(self):
        uri = get_export_object_uri("bucket", "project", "instance", "suffix")
        self.assertEqual(uri, "gs://bucket/backup-project-instance-suffix-201201010000.gz")

    @freeze_time("2012-01-01")
    def test_without_suffix(self):
        uri = get_export_object_uri("bucket", "project", "instance", "")
        self.assertEqual(uri, "gs://bucket/backup-project-instance-201201010000.gz")

if __name__ == '__main__':
    unittest.main()