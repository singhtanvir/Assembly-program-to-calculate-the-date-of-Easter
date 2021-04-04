/*
* @author: Tanvir Singh
* @version: April 4, 2021
* @description: This is the SPARC assembly implementation of the program which calculated date
* of easter based on given year
*/

define(y, 1951)		/* Year */
define(g_r, %l0)	/* G */
define(c_r, %l1)	/* C */
define(x_r, %l2)	/* X */
define(z_r, %l3)	/* Z */
define(d_r, %l4)	/* D */
define(e_r, %l5)	/* E */
define(n_r, %l6)	/* N */
define(s_r, %l7)	/* Temp N */

define(m_r, %o5)	/* Month */

	.global main
main:
	save %sp, -96, %sp

	/*
	*	Calculating G
	*/

	mov y, %o0
	call .rem	/* (Y mod 19) */
	mov 19, %o1

	add %o0, 1, g_r	/* (Y mod 19) + 1 */

	/*
	*	Calculating C
	*/

	mov y, %o0
	call .div	/* (Y / 100) */
	mov 100, %o1

	add %o0, 1, c_r	/* (Y / 100) + 1 */

	/*
	*	Calculating X
	*/

	mov 3, %o0
	call .mul	/* (3C) */
	mov c_r, %o1

	mov %o0, %o2

	mov %o2, %o0
	call .div	/* (3C / 4) */
	mov 4, %o1

	sub %o0, 12, x_r	/* (3C / 4) - 12 */

	/*
	*	Calculating Z
	*/

	mov 8, %o0
	call .mul	/* (8C) */
	mov c_r, %o1

	add %o0, 5, %o2	/* (8C + 5) */

	mov %o2, %o0
	call .div	/* (8C + 5) / 25 */
	mov 25, %o1

	sub %o0, 5, z_r	/* [(8C + 5) / 25] - 5 */

	/*
	*	Calculating D
	*/

	mov 5, %o0
	call .mul	/* (5Y) */
	mov y, %o1

	mov %o0, %o2

	mov %o2, %o0
	call .div	/* (5Y / 4) */
	mov 4, %o1

	sub %o0, x_r, %o2	/* (5Y / 4) - X */
	sub %o2, 10, d_r	/* (5Y / 4) - X - 10 */

	/*
	*	Calculating E
	*/

	mov 11, %o0
	call .mul	/* (11G) */
	mov g_r, %o1

	add %o0, 20, %o2	/* (11G + 20) */

	add %o2, z_r, %o3	/* (11G + 20 + Z) */

	sub %o3, x_r, %o4	/* (11G + 20 + Z - X) */

	mov %o4, %o0
	call .rem			/* (11G + 20 + Z - X) mod 30 */
	mov 30, %o1

	mov %o0, e_r
	/*
	if (E = 25) && (G > 11) {

	}
	*/

	cmp e_r, 25		/* if (E == 25) */
	bne skip
	nop

	cmp g_r, 11		/* if (E == 25) && (G > 11) */
	ble or
	nop

	add e_r, 1, e_r		/* e = e + 1 */

	or:				/* if (E == 25) && (G > 11)  || (E == 24)*/

	cmp e_r, 24
	bne skip
	nop

	add e_r, 1, e_r 	/* e = e + 1 */

	skip:

	/*
	* Calculating N
	*/
	mov 44, %o0

	sub  %o0, e_r, n_r

	cmp n_r, 21
	bge skip_again
	nop

	add n_r, 30, n_r

	skip_again:

	add n_r, 7, s_r		/* (N + 7) */

	add d_r, n_r, %o3	/* (D + N) */

	mov %o3, %o0
	call .rem			/* (D + N) mod 7 */
	mov 7, %o1

	sub s_r, %o0, n_r	/* (N + 7) - ((D + N) mod 7) */

	cmp n_r, 31
	bl set_m
	nop

	mov 4, m_r	/* M = 4 */
	sub n_r, 31, n_r	/* N = N - 31 */

	ba exit
	nop

	set_m:

	mov 3, m_r	/* M = 3 */

	exit:

	mov 1, %g1	!trap dispatch
	ta 0
