
run-test:
	stack run -- -f ./test.ledger -s expenses:mutuo -t liabilities:mutuo liabilities:mutuo -a 0.02 -m 240
