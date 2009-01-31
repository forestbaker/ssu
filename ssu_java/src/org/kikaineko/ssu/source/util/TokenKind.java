/*
 * �쐬���F 2005/02/09
 *
 * TODO ���̐������ꂽ�t�@�C���̃e���v���[�g��ύX����ɂ͎����Q�ƁB
 * �E�B���h�E �� �ݒ� �� Java �� �R�[�h�E�X�^�C�� �� �R�[�h�E�e���v���[�g
 */
package org.kikaineko.ssu.source.util;

/**
 * �I�[�g�}�g���Ŏg�p������Ԃ�\��
 * @author masayuki
 */
public interface TokenKind {
    /** �g�[�N���I�[�g�}�g���̎n�܂��\���B*/
	public static final int Start = 0;
	/** �g�[�N���I�[�g�}�g���̏I����\���B*/
	public static final int End = -1;
	/** ����*/
	public static final int Number = 1;
	/** ' ','\t','\n' �����\��*/
	public static final int Kuuhaku = 2;
	/** ���w�L��*/
	public static final int MathToken = 3;
	/** �ϐ����ȂǁA�ǂ̃g�[�N���ɂ����Ă͂܂�Ȃ�����*/
	public static final int Word = 4;//�ϐ����Ȃ�
	/** = */
	public static final int Eq=5;// =
	/** * */
	public static final int Star = 6;// *
	/** / */
	public static final int Slash = 7;// /
	/** + */
	public static final int Plus = 8;// +
	/** - */
	public static final int Minus = 9; //-
	/** ++ */
	public static final int PP = 10;//++
	/** -- */
	public static final int MM = 11;//--
	/** ** */
	public static final int DoubleStar = 12;//**
	/** ( */
	public static final int OpenKakko = 13;//(
	/** ) */
	public static final int CloseKakko = 14;//)
	/** . */
	public static final int Piriod = 15;// .
	/** " */
	public static final int DoubleQ = 16;//"
	/** ' */
	public static final int SingleQ = 17;//'
	
	/** �G�X�P�[�v�V�[�P���X */
	public static final int Esc = 18; //\
	/** [ */
	public static final int ArrayOpen = 19;//[
	/** ] */
	public static final int ArrayClose = 20;//]
	/** { */
	public static final int BlockOpen = 21;//{
	/** } */
	public static final int BlockClose = 22;//}
	/** == */
	public static final int CondEq = 23;//==
	/** ! */
	public static final int Bikkuri = 24;//!
	/** != */
	public static final int CondNotEq = 25;//!=
	/** <= */
	public static final int CondLE = 26;//<=
	/** < */
	public static final int CondLT = 27;//<
	/** > */
	public static final int CondGT = 28;//>
	/** >= */
	public static final int CondGE = 29;//>=
	/** | */
	public static final int SingleBar = 30;//|
	/** || */
	public static final int DoubleBar = 31;//||
	/** & */
	public static final int SingleAnpa = 32;//&
	/** && */
	public static final int DoubleAnpa = 33;//&&
	/** % */
	public static final int Amari = 34;//%
	/** ^ */
	public static final int Kasa = 35;//^�����
	/** += */
	public static final int SaikiWa = 36; // +=
	/** -= */
	public static final int SaikiSa = 37;//-=
	/** *= */
	public static final int SaikiSeki = 38; //*=
	/** /= */
	public static final int SaikiShou = 39;///=
	/** %= */
	public static final int SaikiAmari = 40;//%=
	/** ? */
	public static final int Quest = 41; //?
	/** : */
	public static final int Koron = 42; //:
	/** ; */
	public static final int SemiKoron = 43;//;
	/** >> */
	public static final int BitMigiShift = 44;//>>
	/** >>> */
	public static final int BitMigiShiftWithZero = 45;//>>>
	/** << */
	public static final int BitHidariShift = 46;//<<
	/** ~ */
	public static final int Tiruda = 47;//~
	/** , */
	public static final int Kanme = 48;// ,
	/** $ */
	public static final int Doller = 49;//$
	
	/** /* */
	public static final int CommentOpen = 50;// /*
	/** *\/ */
	public static final int CommentClose = 51; // */
	/** // */
	public static final int LineComment = 52; // //
	
	/** ������ */
	public static final int STring = 53; // ������
	/** �ꕶ�� */
	public static final int Char = 54; // ����
	
	public static final int AttMark=55; //@

	public static final int Sharpe=56; //#
	
	public static final int WithSharpe=57; //-#�Ƃ�
}
