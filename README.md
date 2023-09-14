# ZoKrates Test Environment and Crucible

#### Architecture

Works in both arm64 and amd64!

## Overview

A development playground provides a safe and isolated environment where software developers can experiment, test, and iterate on ZoKrates zkSNARKS. They can generate code, Solidity components, or an entire proof. This is a space separate from a production environment where developers can try out new ideas, troubleshoot issues, and learn without affecting the actual users or systems.

Key features of Zokrates Crucible development playground:

1. **Isolation:** The playground is disconnected from the live or production systems to prevent accidental changes or disruptions to the actual user experience.

2. **Testing and Iteration:** Developers can quickly test code changes, new features, or modifications without fear of causing problems for users. This enables them to iterate and refine their work before deploying it to production.

3. **Learning and Exploration:** Developers can experiment with new technologies, libraries, frameworks, and approaches to gain hands-on experience and learn without consequences.

4. **Troubleshooting:** Developers can reproduce and investigate issues reported by users in a controlled environment, making it easier to diagnose and fix problems without affecting the live system.

5. **Collaboration:** Development playgrounds can also facilitate collaboration among team members. Developers can share their work with colleagues for feedback and review before finalizing changes.

6. **Staging:** In some cases, a development playground might serve as a staging environment, where changes are thoroughly tested before being promoted to the production environment.

7. **Version Control:** Modern development playgrounds often integrate with version control systems, allowing developers to track changes, collaborate, and manage different versions of their code.


## Example

Prove that Prover, Peggy knows the square root of a quadradic residue mod n.   This is cryptographically similar in difficulty to the discrete logarithm problem.

1. `zokrates compile -i src/sqrt.zok `
2. `zokrates setup`
### 256 bit number is not cryptogrphically secure - used for example
3. `zokrates compute-witness -a 105503353341635251739388807057048439745 5906876347610788132374914526238871430 142433102793350311139494996326894655391`
4. `zokrates generate-proof`
5. `zokrates export-verifier`
6. `zokrates verify`

### Simple Example - Calculator test

`zokrates compute-witness -a 1529 3878 5879`

### Strong Encryption 1024 bit example

`zokrates compute-witness -a 8316257881641021803582905045717248206056718946016883409345574565136922113375339185405930244923042687180817302566013120911495945967850843772303215152494233 9872291329696295407337711770023368047044283358907128526510010117886524991212042657797091303026873836609390626022927092784183453775270320719649472866081175 11827058731941270008765010504059650034033355481454192607091635073002083084605790970710373730279239889399395303258055587536080559285758863055719494590037407`
