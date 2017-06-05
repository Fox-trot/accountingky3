﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Свод начислений и удержаний.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'Вид
		|Дни
		|Часы
		|Сумма
		|Всего начислено
		|Всего удержано
		|Всего выплачено
		|Сумма долга по зарплате за сотрудником
		|Остаток на конец'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Организация'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Свод начислений и удержаний'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
// ПараметрыОтчета - структура - набор параметров, необходимых для построения отчета.
// 	АдресХранилища - адрес временного хранилища.
Процедура Сформировать(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

// Процедура - Сформировать табличный документ
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  РезультатФормирования	 	- Структура - 
//
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ЧерноБелаяПечать = Истина;
	
	Организация = СтруктураПараметров.Организация;
	НачалоПериода = НачалоДня(СтруктураПараметров.НачалоПериода);
	КонецПериода = КонецДня(СтруктураПараметров.КонецПериода);
	
	Макет = ПолучитьМакет("ПФ_MXL_СводНачисленийИУдержаний");

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ПериодПредставление = ПредставлениеПериода(НачалоПериода, КонецПериода);
	ТабличныйДокумент.Вывести(ОбластьШапка);
	
	ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы1");
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	// Части 1 и 2
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса =	
	"ВЫБРАТЬ
	|	""3а. Выплаченные суммы по Ведомостям ЗП предыдущих периодов"" КАК ВидОперации,
	|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК Сумма,
	|	ВыплаченнаяЗарплатаОбороты.ПериодРегистрации,
	|	ВыплаченнаяЗарплатаОбороты.Ведомость КАК Ведомость,
	|	ВыплаченнаяЗарплатаОбороты.Ведомость.Представление КАК ВедомостьПредставление
	|ПОМЕСТИТЬ ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов
	|ИЗ
	|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			Организация = &Организация
	|				И ПериодРегистрации < &НачалоПериода) КАК ВыплаченнаяЗарплатаОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""3б. Выплаченные суммы по Ведомостям ЗП текущего месяца"" КАК ВидОперации,
	|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК Сумма,
	|	ВыплаченнаяЗарплатаОбороты.Ведомость КАК Ведомость,
	|	ВыплаченнаяЗарплатаОбороты.Ведомость.Представление КАК ВедомостьПредставление
	|ПОМЕСТИТЬ ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц
	|ИЗ
	|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			Организация = &Организация
	|				И (ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода)) КАК ВыплаченнаяЗарплатаОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВременнаяТаблицаВыплачено
	|ИЗ
	|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц КАК ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СУММА(ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.Сумма)
	|ИЗ
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов КАК ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""1.Начислено"" КАК ВидОперации,
	|	СУММА(Начисления.Результат) КАК СуммаНачисления,
	|	СУММА(Начисления.ОтработаноДней) КАК ОтработаноДней,
	|	СУММА(Начисления.ОтработаноЧасов) КАК ОтработаноЧасов,
	|	Начисления.ВидРасчета.Код + "" "" + Начисления.ВидРасчета.Наименование КАК ВидНачисления
	|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Начисления.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	Начисления.ВидРасчета.Код + "" "" + Начисления.ВидРасчета.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""2.Удержано"" КАК ВидОперации,
	|	Удержания.ВидРасчета.Код + "" "" + Удержания.ВидРасчета.Наименование КАК ВидУдержания,
	|	Удержания.Результат КАК СуммаУдержания
	|ПОМЕСТИТЬ ВременнаяТаблицаУдержания
	|ИЗ
	|	РегистрРасчета.Удержания КАК Удержания
	|ГДЕ
	|	Удержания.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Удержания.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПН)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.Кыргызпрофсож)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.Рабпрофсож)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФР)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФРДоп)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ГНПФР)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПНРК)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПрофВзнос)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Налоги"",
	|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	|	Налоги.СуммаОборот
	|ИЗ
	|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФРРК)) КАК Налоги
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Удержано"",
	|	""897 (Через банк)"",
	|	ВзаиморасчетыССотрудникамиОбороты.СуммаРасход
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыССотрудниками.Обороты(&НачалоПериода, &КонецПериода, Авто, Организация = &Организация) КАК ВзаиморасчетыССотрудникамиОбороты
	|ГДЕ
	|	ВзаиморасчетыССотрудникамиОбороты.Регистратор ССЫЛКА Документ.ВедомостьЗП
	|	И ВЫРАЗИТЬ(ВзаиморасчетыССотрудникамиОбороты.Регистратор КАК Документ.ВедомостьЗП).ВидВыплаты = ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезБанк)
	|	И НЕ ВЫРАЗИТЬ(ВзаиморасчетыССотрудникамиОбороты.Регистратор КАК Документ.ВедомостьЗП).ВыплатаАванса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаНачисления.ВидОперации,
	|	СУММА(ВременнаяТаблицаНачисления.СуммаНачисления) КАК СуммаНачисления,
	|	СУММА(ВременнаяТаблицаНачисления.ОтработаноДней) КАК ОтработаноДней,
	|	СУММА(ВременнаяТаблицаНачисления.ОтработаноЧасов) КАК ОтработаноЧасов,
	|	ВременнаяТаблицаНачисления.ВидНачисления КАК ВидНачисления
	|ИЗ
	|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаНачисления.ВидОперации,
	|	ВременнаяТаблицаНачисления.ВидНачисления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаУдержания.ВидУдержания КАК ВидУдержания,
	|	СУММА(ВременнаяТаблицаУдержания.СуммаУдержания) КАК СуммаУдержания
	|ИЗ
	|	ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаУдержания.ВидУдержания
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидУдержания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВременнаяТаблицаВыплачено.Сумма) КАК Сумма
	|ИЗ
	|	ВременнаяТаблицаВыплачено КАК ВременнаяТаблицаВыплачено
	|;	
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыССотрудникамиОстаткиИОбороты.СуммаКонечныйОстаток КАК ОстатокНаКонец,
	|	ВзаиморасчетыССотрудникамиОстаткиИОбороты.СуммаНачальныйОстаток КАК ОстатокНаНачало
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыССотрудниками.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , Организация = &Организация) КАК ВзаиморасчетыССотрудникамиОстаткиИОбороты";
	//"ВЫБРАТЬ
	//|	""3а. Выплаченные суммы по Ведомостям ЗП предыдущих периодов"" КАК ВидОперации,
	//|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК Сумма,
	//|	ВыплаченнаяЗарплатаОбороты.ПериодРегистрации,
	//|	ВыплаченнаяЗарплатаОбороты.Ведомость КАК Ведомость,
	//|	ВыплаченнаяЗарплатаОбороты.Ведомость.Представление КАК ВедомостьПредставление
	//|ПОМЕСТИТЬ ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов
	//|ИЗ
	//|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			Авто,
	//|			Организация = &Организация
	//|				И ПериодРегистрации < &НачалоПериода) КАК ВыплаченнаяЗарплатаОбороты
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	""3б. Выплаченные суммы по Ведомостям ЗП текущего месяца"" КАК ВидОперации,
	//|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК Сумма,
	//|	ВыплаченнаяЗарплатаОбороты.Ведомость КАК Ведомость,
	//|	ВыплаченнаяЗарплатаОбороты.Ведомость.Представление КАК ВедомостьПредставление
	//|ПОМЕСТИТЬ ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц
	//|ИЗ
	//|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			Авто,
	//|			Организация = &Организация
	//|				И (ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода)) КАК ВыплаченнаяЗарплатаОбороты
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	СУММА(ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц.Сумма) КАК Сумма
	//|ПОМЕСТИТЬ ВременнаяТаблицаВыплачено
	//|ИЗ
	//|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц КАК ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	СУММА(ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.Сумма)
	//|ИЗ
	//|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов КАК ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	""1.Начислено"" КАК ВидОперации,
	//|	СУММА(Начисления.Результат) КАК СуммаНачисления,
	//|	СУММА(Начисления.ОтработаноДней) КАК ОтработаноДней,
	//|	СУММА(Начисления.ОтработаноЧасов) КАК ОтработаноЧасов,
	//|	Начисления.ВидРасчета.Код + "" "" + Начисления.ВидРасчета.Наименование КАК ВидНачисления
	//|ПОМЕСТИТЬ ВременнаяТаблицаНачисления
	//|ИЗ
	//|	РегистрРасчета.Начисления КАК Начисления
	//|ГДЕ
	//|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
	//|	И Начисления.Организация = &Организация
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	Начисления.ВидРасчета.Код + "" "" + Начисления.ВидРасчета.Наименование
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	""1.Начислено"",
	//|	0,
	//|	NULL,
	//|	СУММА(СведенияПоНеявкам.КоличествоЧасов),
	//|	СведенияПоНеявкам.ВидРасчета.Код + "" "" + СведенияПоНеявкам.ВидРасчета.Наименование
	//|ИЗ
	//|	РегистрСведений.СведенияПоНеявкам КАК СведенияПоНеявкам
	//|ГДЕ
	//|	СведенияПоНеявкам.Организация = &Организация
	//|	И СведенияПоНеявкам.ДатаНачала >= &НачалоПериода
	//|	И СведенияПоНеявкам.ДатаОкончания <= &КонецПериода
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	СведенияПоНеявкам.ВидРасчета.Код + "" "" + СведенияПоНеявкам.ВидРасчета.Наименование
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	""2.Удержано"" КАК ВидОперации,
	//|	Удержания.ВидРасчета.Код + "" "" + Удержания.ВидРасчета.Наименование КАК ВидУдержания,
	//|	Удержания.Результат КАК СуммаУдержания
	//|ПОМЕСТИТЬ ВременнаяТаблицаУдержания
	//|ИЗ
	//|	РегистрРасчета.Удержания КАК Удержания
	//|ГДЕ
	//|	Удержания.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
	//|	И Удержания.Организация = &Организация
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	""Налоги"",
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПН)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.Кыргызпрофсож)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.Рабпрофсож)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФР)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФРДоп)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ГНПФР)) КАК Налоги
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	NULL,
	//|	Налоги.ВидНалога.Код + "" "" + Налоги.ВидНалога.Наименование,
	//|	Налоги.СуммаОборот
	//|ИЗ
	//|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
	//|			&НачалоПериода,
	//|			&КонецПериода,
	//|			,
	//|			Организация = &Организация
	//|				И ВидНалога = ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПНРК)) КАК Налоги
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВременнаяТаблицаНачисления.ВидОперации,
	//|	СУММА(ВременнаяТаблицаНачисления.СуммаНачисления) КАК СуммаНачисления,
	//|	СУММА(ВременнаяТаблицаНачисления.ОтработаноДней) КАК ОтработаноДней,
	//|	СУММА(ВременнаяТаблицаНачисления.ОтработаноЧасов) КАК ОтработаноЧасов,
	//|	ВременнаяТаблицаНачисления.ВидНачисления КАК ВидНачисления
	//|ИЗ
	//|	ВременнаяТаблицаНачисления КАК ВременнаяТаблицаНачисления
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ВременнаяТаблицаНачисления.ВидОперации,
	//|	ВременнаяТаблицаНачисления.ВидНачисления
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ВидНачисления
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ВременнаяТаблицаУдержания.ВидОперации,
	//|	ВременнаяТаблицаУдержания.ВидУдержания КАК ВидУдержания,
	//|	СУММА(ВременнаяТаблицаУдержания.СуммаУдержания) КАК СуммаУдержания
	//|ИЗ
	//|	ВременнаяТаблицаУдержания КАК ВременнаяТаблицаУдержания
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ВременнаяТаблицаУдержания.ВидОперации,
	//|	ВременнаяТаблицаУдержания.ВидУдержания
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ВидУдержания
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	СУММА(ВременнаяТаблицаВыплачено.Сумма) КАК Сумма
	//|ИЗ
	//|	ВременнаяТаблицаВыплачено КАК ВременнаяТаблицаВыплачено";	
	
	Запрос.УстановитьПараметр("НачалоПериода",	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",	КонецПериода);
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "Истина");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Начисления.Организация = &Организация", "Истина");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Удержания.Организация = &Организация", "Истина");
		
	КонецЕсли;		
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса 	= Запрос.ВыполнитьПакет();
	ТаблицаНачисления 	= РезультатЗапроса[5].Выгрузить();
	ТаблицаУдержания 	= РезультатЗапроса[6].Выгрузить();
	//ТаблицаНалоги 		= РезультатЗапроса[6].Выгрузить();
	ТаблицаВыплачено	= РезультатЗапроса[7].Выгрузить();
	ТаблицаОстатков		= РезультатЗапроса[8].Выбрать();
	
	//Остатки
	ОстатокНаНачало = 0;
	ОстатокНаКонец = 0;
	ОбластьОстаток	= Макет.ПолучитьОбласть("ОстатокНаНачало");
	Если ТаблицаОстатков.Следующий() Тогда 
		ОстатокНаНачало = ТаблицаОстатков.ОстатокНаНачало;
		ОстатокНаКонец =  ТаблицаОстатков.ОстатокНаКонец;
	КонецЕсли;
	ОбластьОстаток.Параметры.ОстатокНаНачало = ОстатокНаНачало;
	ТабличныйДокумент.Вывести(ОбластьОстаток);	
	//Остатки>>
	
	
	СуммаИтогНачисления = 0;
	СуммаИтогУдержания = 0;
	
	КоличествоНачисления = ТаблицаНачисления.Количество();
	КоличествоУдержания = ТаблицаУдержания.Количество();
	//КоличествоНалогов = ТаблицаНалоги.Колонки.Количество();
	//КоличествоНалогов = ТаблицаНалоги.Количество();
	ИндексКолонки = 0;
	
	КоличествоШагов = Макс(КоличествоНачисления, КоличествоУдержания);
	Для Счетчик = 0 По КоличествоШагов - 1 Цикл
		ОбластьСтрока	= Макет.ПолучитьОбласть("Строка1");
		Если КоличествоНачисления > Счетчик Тогда			
			ОбластьСтрока.Параметры.Заполнить(ТаблицаНачисления[Счетчик]);
			СуммаИтогНачисления = СуммаИтогНачисления  + ТаблицаНачисления[Счетчик].СуммаНачисления;	
		КонецЕсли;
		Если КоличествоУдержания > Счетчик Тогда			
			ОбластьСтрока.Параметры.Заполнить(ТаблицаУдержания[Счетчик]);
			СуммаИтогУдержания = СуммаИтогУдержания  + ТаблицаУдержания[Счетчик].СуммаУдержания;
		//Иначе
		//	Если ИндексКолонки < КоличествоНалогов Тогда
		//	//Если КоличествоНалогов > Счетчик Тогда
		//		
		//		//ОбластьСтрока.Параметры.ВидУдержания 	= ТаблицаНалоги.Колонки[ИндексКолонки].Имя;
		//		//ОбластьСтрока.Параметры.СуммаУдержания 	= ТаблицаНалоги[0][ТаблицаНалоги.Колонки[ИндексКолонки].Имя];
		//		
		//		ОбластьСтрока.Параметры.Заполнить(ТаблицаНалоги[ИндексКолонки]);
		//		
		//		СуммаИтогУдержания = СуммаИтогУдержания  + ОбластьСтрока.Параметры.СуммаУдержания;
		//		ИндексКолонки = ИндексКолонки + 1;			
		//	КонецЕсли;
			
		КонецЕсли;		
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	//КоличествоШагов = Макс(КоличествоНачисления, КоличествоУдержания + КоличествоНалогов);
	//Для Счетчик = 0 По КоличествоШагов - 1 Цикл
	//	ОбластьСтрока	= Макет.ПолучитьОбласть("Строка1");
	//	Если КоличествоНачисления > Счетчик Тогда			
	//		ОбластьСтрока.Параметры.Заполнить(ТаблицаНачисления[Счетчик]);
	//		СуммаИтогНачисления = СуммаИтогНачисления  + ТаблицаНачисления[Счетчик].СуммаНачисления;	
	//	КонецЕсли;
	//	Если КоличествоУдержания > Счетчик Тогда			
	//		ОбластьСтрока.Параметры.Заполнить(ТаблицаУдержания[Счетчик]);
	//		СуммаИтогУдержания = СуммаИтогУдержания  + ТаблицаУдержания[Счетчик].СуммаУдержания;
	//	Иначе
	//		Если ИндексКолонки < КоличествоНалогов Тогда
	//		//Если КоличествоНалогов > Счетчик Тогда
	//			
	//			//ОбластьСтрока.Параметры.ВидУдержания 	= ТаблицаНалоги.Колонки[ИндексКолонки].Имя;
	//			//ОбластьСтрока.Параметры.СуммаУдержания 	= ТаблицаНалоги[0][ТаблицаНалоги.Колонки[ИндексКолонки].Имя];
	//			
	//			ОбластьСтрока.Параметры.Заполнить(ТаблицаНалоги[ИндексКолонки]);
	//			
	//			СуммаИтогУдержания = СуммаИтогУдержания  + ОбластьСтрока.Параметры.СуммаУдержания;
	//			ИндексКолонки = ИндексКолонки + 1;			
	//		КонецЕсли;
	//		
	//	КонецЕсли;		
	//	ТабличныйДокумент.Вывести(ОбластьСтрока);
	//КонецЦикла;                                           
	
	Если ТаблицаВыплачено.Количество() = 0 Тогда
		СуммаВыплачено = 0;	
	Иначе
		СуммаВыплачено = ТаблицаВыплачено[0].Сумма;	
	КонецЕсли;
	
	СуммаВыплачено = ?(ЗначениеЗаполнено(СуммаВыплачено),СуммаВыплачено,0);
	
	ИтогОбщий1	= Макет.ПолучитьОбласть("Итог1");
	ИтогОбщий1.Параметры.СуммаНачисления 	= СуммаИтогНачисления;
	ИтогОбщий1.Параметры.СуммаУдержания		= СуммаИтогУдержания;
	ИтогОбщий1.Параметры.СуммаДолга			= СуммаИтогНачисления - СуммаИтогУдержания - СуммаВыплачено;
	ТабличныйДокумент.Вывести(ИтогОбщий1);

	// Часть 3. Выплаченные суммы 
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""3а. Выплаченные суммы по Ведомостям ЗП предыдущих периодов"" КАК ВидОперации,
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.Сумма КАК Сумма,
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.ПериодРегистрации КАК ПериодРегистрации,
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.Ведомость КАК Ведомость,
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов.ВедомостьПредставление КАК ВедомостьПредставление
	|ИЗ
	|	ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов КАК ВременнаяТаблицаВыплаченныеСуммыПредыдущихПериодов
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ведомость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""3б. Выплаченные суммы по Ведомостям ЗП текущего месяца"" КАК ВидОперации,
	|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц.Сумма КАК Сумма,
	|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц.Ведомость КАК Ведомость,
	|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц.ВедомостьПредставление КАК ВедомостьПредставление
	|ИЗ
	|	ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц КАК ВременнаяТаблицаВыплаченныеСуммыЗаТекущийМесяц
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ведомость";
	
	Запрос.УстановитьПараметр("НачалоПериода",	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",	КонецПериода);
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "Истина");
	КонецЕсли;		
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса 	= Запрос.ВыполнитьПакет();
	
	ВыборкаПредПериод 	= РезультатЗапроса[0].Выбрать();
	ВыборкаТекПериод 	= РезультатЗапроса[1].Выбрать();	
		
	ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы2");
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	// выплаты за пред. период
	СуммаИтогВедомостиПредПериод = 0;	
	Пока ВыборкаПредПериод.Следующий() Цикл
		ОбластьСтрока	= Макет.ПолучитьОбласть("Строка2");
		ОбластьСтрока.Параметры.Документ 		= ВыборкаПредПериод.ВедомостьПредставление;
		ОбластьСтрока.Параметры.СуммаВыплачено 	= ВыборкаПредПериод.Сумма;
		СуммаИтогВедомостиПредПериод = СуммаИтогВедомостиПредПериод + ВыборкаПредПериод.Сумма;
	    ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;	
	
	ИтогЗаПериод	= Макет.ПолучитьОбласть("ИтогЗаПериод");
	ИтогЗаПериод.Параметры.ВидВыплаты 		= "Итого выплат за пред. период";
	ИтогЗаПериод.Параметры.СуммаВыплачено	= СуммаИтогВедомостиПредПериод;
	ТабличныйДокумент.Вывести(ИтогЗаПериод);	
	
	// выплаты за тек. период
	СуммаИтогВедомостиТекПериод = 0;	
	Пока ВыборкаТекПериод.Следующий() Цикл
		ОбластьСтрока	= Макет.ПолучитьОбласть("Строка2");
		ОбластьСтрока.Параметры.Документ 		= ВыборкаТекПериод.ВедомостьПредставление;
		ОбластьСтрока.Параметры.СуммаВыплачено 	= ВыборкаТекПериод.Сумма;
		СуммаИтогВедомостиТекПериод = СуммаИтогВедомостиТекПериод + ВыборкаТекПериод.Сумма;
	    ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;	
	
	ИтогЗаПериод	= Макет.ПолучитьОбласть("ИтогЗаПериод");
	ИтогЗаПериод.Параметры.ВидВыплаты 		= "Итого выплат за тек. период";
	ИтогЗаПериод.Параметры.СуммаВыплачено	= СуммаИтогВедомостиТекПериод;
	ТабличныйДокумент.Вывести(ИтогЗаПериод);	
	
	ИтогЗаПериод	= Макет.ПолучитьОбласть("Итог3");
	ИтогЗаПериод.Параметры.СуммаВыплачено	= СуммаИтогВедомостиПредПериод + СуммаИтогВедомостиТекПериод;
	ТабличныйДокумент.Вывести(ИтогЗаПериод);	
	
	//Остатки на конец
	ОбластьОстаток	= Макет.ПолучитьОбласть("ОстатокНаКонец");
	ОбластьОстаток.Параметры.ОстатокНаКонец = ОстатокНаКонец;	
	ТабличныйДокумент.Вывести(ОбластьОстаток);	
	//Остатки на конец>>

	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	РезультатФормирования.Результат = ТабличныйДокумент;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
