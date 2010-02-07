/*
 * Generated by asn1c-0.9.21 (http://lionet.info/asn1c)
 * From ASN.1 module "FEF-IntermediateDraft"
 * 	found in "../annexb-snacc-122001.asn1"
 */

#ifndef	_AbsoluteTime_H_
#define	_AbsoluteTime_H_


#include <asn_application.h>

/* Including external dependencies */
#include <GeneralizedTime.h>

#ifdef __cplusplus
extern "C" {
#endif

/* AbsoluteTime */
typedef GeneralizedTime_t	 AbsoluteTime_t;

/* Implementation */
extern asn_TYPE_descriptor_t asn_DEF_AbsoluteTime;
asn_struct_free_f AbsoluteTime_free;
asn_struct_print_f AbsoluteTime_print;
asn_constr_check_f AbsoluteTime_constraint;
ber_type_decoder_f AbsoluteTime_decode_ber;
der_type_encoder_f AbsoluteTime_encode_der;
xer_type_decoder_f AbsoluteTime_decode_xer;
xer_type_encoder_f AbsoluteTime_encode_xer;

#ifdef __cplusplus
}
#endif

#endif	/* _AbsoluteTime_H_ */