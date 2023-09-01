import { Blockchain, SandboxContract } from '@ton-community/sandbox';
import { toNano } from 'ton-core';
import { Lotton } from '../wrappers/Lotton';
import '@ton-community/test-utils';

describe('Lotton', () => {
    let blockchain: Blockchain;
    let lotton: SandboxContract<Lotton>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        lotton = blockchain.openContract(await Lotton.fromInit());

        const deployer = await blockchain.treasury('deployer');

        const deployResult = await lotton.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: lotton.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and lotton are ready to use
    });
});
