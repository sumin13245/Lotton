import { toNano } from 'ton-core';
import { Lotton } from '../wrappers/Lotton';
import { NetworkProvider } from '@ton-community/blueprint';

export async function run(provider: NetworkProvider) {
    const lotton = provider.open(await Lotton.fromInit());

    await lotton.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(lotton.address);

    // run methods on `lotton`
}
