class TestRPM(object):
    def test_version(self):
        import rpm
        print(rpm.__version__)

    def test_transaction(self):
        import rpm
        print(rpm.TransactionSet().dbMatch('name', 'rpm'))
