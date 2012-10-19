exports.tests =
	setUp: (done) ->
		done()

	"no args": (test) ->
		# test.expect(1)
		# tests here
		test.equal("awesome", "awesome", "should be awesome.")
		test.done()
