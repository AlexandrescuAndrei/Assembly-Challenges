# Assembly-Challenges

A collection of low-level programming exercises implemented in **x86 Assembly**, focused on bit manipulation, memory access, sorting, cryptographic transformations, matrix traversal, and direct register-level programming.

The repository contains four main tasks, each approaching a different type of problem entirely from assembly. Instead of relying on high-level data structures or library abstractions, the implementations work directly with registers, stack operations, memory offsets, bit masks, loops, comparisons, and pointer arithmetic.

The exercises cover permission verification encoded inside integers, sorting structured records using multiple criteria, analyzing binary passkeys, implementing the Treyfer block cipher in both directions, and navigating a labyrinth represented as a matrix.

The project was useful for understanding how algorithms that are relatively straightforward in a higher-level language have to be decomposed into much smaller operations when implemented directly in assembly.

## Permission Checking with Bit Masks

The first task implements a permission-checking system based entirely on bit manipulation.

A single 32-bit value contains two different pieces of information. The upper 8 bits represent an identifier, while the lower 24 bits represent a set of requested permissions.

The implementation separates these two components using shift operations.

The lower 24 bits are isolated and stored as the permission mask corresponding to the requested rooms. The upper 8 bits are shifted into the lower part of another register and used as an index into an external permission table.

Once the permission mask associated with the corresponding identifier is loaded, a bitwise `AND` operation is performed between the available permissions and the requested permissions.

If the result is identical to the complete requested mask, every requested permission is available and the result is set to true. Otherwise, the request is rejected.

This task is mainly based on understanding binary representations and using bit masks efficiently instead of testing individual permissions one at a time.

It also involves indexed memory access, since the extracted identifier is used to locate the appropriate 32-bit entry inside the permissions array.

## Request Sorting and Structured Data

The second task works with an array of structured request records stored directly in memory.

Each record occupies 55 bytes, so accessing an element requires manually calculating its address from the base pointer and the current index.

The sorting implementation repeatedly compares records and exchanges their complete 55-byte memory regions when they are found in the wrong order.

Unlike sorting a simple integer array, the comparison uses several fields from each structure.

The first byte is checked first. If this does not determine the ordering, the second byte is compared. If the first two criteria are equal, the implementation continues by comparing the username stored inside the structure character by character.

This creates a multi-criteria comparison entirely in assembly.

The swap operation also has to be implemented manually. Instead of exchanging references or using a library function, the code iterates through all 55 bytes and exchanges the contents of the two structures byte by byte.

This task required careful management of registers because the same registers are needed for indexes, addresses, comparison values, and temporary data. Values that must survive part of the algorithm are temporarily preserved on the stack and restored after the comparison is finished.

It is a good example of how arrays of structures are represented in memory and how operations such as indexing, comparison, and swapping eventually reduce to address calculations and byte-level memory operations.

## Passkey Analysis

Another part of the second task analyzes 16-bit passkeys and determines whether they satisfy a specific collection of binary properties.

Each request contains a passkey stored inside its 55-byte record.

The implementation extracts the passkey and evaluates several conditions directly at bit level.

The least significant bit is checked first, followed by the most significant bit. The passkey is then divided logically into its lower and upper 8-bit halves.

The number of set bits in each half is counted manually using masks and shifts.

For the lower eight bits, the implementation verifies the required parity of the number of bits equal to one. A similar check is then performed for the upper eight bits using the opposite parity condition required by the task.

If any condition fails, the corresponding request is marked as not matching the required passkey pattern. If every binary condition is satisfied, the result for that request is set accordingly.

The operation is repeated for every element of the request array, with the output written into a separate result array.

This part of the project focuses heavily on bitwise operations such as `AND`, shifts, masks, and parity checks, as well as on extracting smaller fields from larger binary values.

## Treyfer Encryption and Decryption

The third task implements both encryption and decryption for the **Treyfer block cipher**.

The implementation works with an 8-byte text block and an 8-byte secret key.

A predefined substitution box containing 256 values is included directly in the assembly source, and the transformation is repeated for 10 rounds.

During encryption, the algorithm keeps an intermediate value in an 8-bit register.

For every byte position, the corresponding key byte is added to the current value. The result is used as an index into the substitution box, after which the next byte of the text block is incorporated into the transformation.

A one-bit left rotation is then applied and the appropriate byte inside the block is updated.

The transition from the last byte back to the first is handled explicitly so that the next position behaves as `(i + 1) % 8`.

The entire process is repeated across all eight positions for every encryption round.

Decryption performs the inverse transformation.

The bytes are processed in reverse order, beginning from the final position of the block. The same key and substitution table are used, but the rotation and arithmetic operations are reversed so that the original block can be reconstructed.

A right rotation is used where encryption performs a left rotation, and the transformation based on the substituted value is reversed through subtraction.

Implementing both directions directly in assembly required careful control over byte-sized registers, temporary values, array indexes, wrap-around behavior, and the order in which the transformations are performed.

## Labyrinth Traversal

The fourth task implements the traversal of a labyrinth represented as a two-dimensional character matrix.

The function receives the number of rows and columns, the address of the matrix, and two output pointers used to return the coordinates of the exit.

Traversal starts from the initial position and continues until the current cell reaches either the final row or the final column.

Visited cells are marked directly in the labyrinth by replacing their value with `'1'`. This prevents the algorithm from returning to positions that were already processed.

At each step, neighboring cells are inspected according to the movement logic implemented by the task.

The code checks directions while also handling matrix boundaries manually. Moving north or west, for example, requires checking whether the resulting row or column would become negative before attempting to access the corresponding memory.

Accessing an element of the matrix also requires manual pointer calculations.

Because the labyrinth is represented as a `char **`, the implementation first calculates the location of the pointer corresponding to the desired row, loads that pointer, and then adds the column offset to reach the required cell.

Once the traversal reaches the exit condition, the final row and column are written through the output pointers supplied to the function.

This task combines pointer arithmetic, multidimensional memory access, boundary checking, state modification, and control flow using jumps and labels.

## Working Directly with Memory and Registers

Across all four tasks, most operations that would normally be handled automatically in a higher-level language have to be implemented explicitly.

Array indexing requires calculating offsets manually. Structured records require knowing the exact size and position of every field. Temporary values have to be assigned to registers or stored on the stack when there are not enough registers available.

The code makes extensive use of registers such as `EAX`, `EBX`, `ECX`, `EDX`, `ESI`, and `EDI`, together with their smaller 8-bit and 16-bit variants when working with characters, bit fields, and passkeys.

The stack is also used to preserve values while registers are temporarily reused for comparisons or address calculations.

Control flow is implemented through labels, conditional jumps, and explicit loop conditions rather than language-level `for`, `while`, or `if` statements.

The project therefore covers more than the individual algorithms themselves. It also provides practice with calling conventions, stack frames, register preservation, pointer arithmetic, binary data representation, and translating higher-level algorithmic ideas into lower-level instructions.

## Project Structure

The repository is divided according to the four main tasks:

- `task-1/check_permission.asm` — extracts an identifier and permission mask from a packed value and validates the requested permissions using bitwise operations
- `task-2/subtask1.asm` — sorts 55-byte request structures using multiple comparison criteria
- `task-2/subtask2.asm` — analyzes 16-bit passkeys using individual bits and bit-count parity rules
- `task-3/treyfer.asm` — implements Treyfer encryption and decryption for 8-byte blocks using a substitution box and multiple rounds
- `task-4/labyrinth.asm` — traverses a two-dimensional labyrinth and returns the coordinates of its exit
- `README` — original implementation notes describing the approach taken for each task

The repository contains the assembly implementations themselves rather than the complete surrounding assignment infrastructure.

The source files reference supporting components such as `io.mac` and external symbols provided by the original environment, so they are intended to be integrated with that support code rather than treated as completely standalone executables.

## Technologies and Concepts

- x86 Assembly
- NASM syntax
- 32-bit registers
- Bitwise operations
- Bit masks
- Binary data representation
- Bit shifting
- Bit rotation
- Register-level programming
- Stack operations
- Stack frames
- Pointer arithmetic
- Manual memory addressing
- Arrays of structures
- Multi-criteria sorting
- Byte-level data manipulation
- Structured memory layouts
- Passkey analysis
- Bit counting and parity
- Treyfer block cipher
- Encryption and decryption
- Substitution boxes
- Matrix traversal
- Boundary checking
- Conditional jumps
- Low-level control flow
- Calling conventions
