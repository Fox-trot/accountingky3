﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	Если НЕ ЗначениеЗаполнено(ПорядокОкругления) Тогда
		ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_01;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		Если ЗначениеЗаполнено(Дата) Тогда
			ПериодРегистрации = НачалоМесяца(Дата);
		Иначе
			ПериодРегистрации = НачалоМесяца(ТекущаяДата());		
		КонецЕсли;
	КонецЕсли;		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ВедомостьЗП.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ); 
	
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
КонецПроцедуры

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Зарплата");
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
	Если ВидВыплаты = ПредопределенноеЗначение("Перечисление.ВидыВыплатыЗарплаты.ЧерезБанк") Тогда 
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Касса");
	Иначе 
		БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "БанковскийСчет");
	КонецЕсли;	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаДокумента = Зарплата.Итог("СуммаКВыплате");
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт 
	
	// 1. Получение сведений о сотрудниках, их карт счетах и подразделении
	// 2. Получение суммы к выплате
	// 3. Округление суммы, с учетом выплаты всего остатка при увольнении	
	
	ВидЗаполнения = ДополнительныеСвойства.ВидЗаполненияТабличнойЧасти;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Сотрудники, признак увольнения для выплаты всего остатка
	// Карт счета для определения банка
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо,
		|	СотрудникиСрезПоследних.Подразделение,
		|	ВЫБОР
		|		КОГДА СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Уволен,
		|	КартСчетаСотрудников.Банк,
		|	КартСчетаСотрудников.НомерСчета КАК НомерЛицевогоСчета
		|ПОМЕСТИТЬ ВременнаяТаблицаСотрудники
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&КонецПериода, Организация = &Организация) КАК СотрудникиСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КартСчетаСотрудников КАК КартСчетаСотрудников
		|		ПО СотрудникиСрезПоследних.ФизЛицо = КартСчетаСотрудников.ФизЛицо
		|			И (КартСчетаСотрудников.Банк = &Банк)
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение = &Подразделение";
	Если ЗначениеЗаполнено(Подразделение) Тогда  
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Иначе 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СотрудникиСрезПоследних.Подразделение = &Подразделение", "ИСТИНА");	
	КонецЕсли;	
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Банк", БанковскийСчетПолучателя.Банк);
	РезультатЗапроса = Запрос.Выполнить();

	// Остатки по счету 3520
	Если ВидЗаполнения = "ЗаполнитьПоОстаткам" Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ХозрасчетныйОстатки.Субконто1 КАК ФизЛицо,
			|	ХозрасчетныйОстатки.СуммаОстатокКт КАК СуммаКВыплате
			|ПОМЕСТИТЬ ВременнаяТаблицаРассчитанныеСуммы
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.Остатки(
			|			&КонецПериода,
			|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
			|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
			|			Организация = &Организация
			|				И Субконто1 В
			|					(ВЫБРАТЬ
			|						ВременнаяТаблицаСотрудники.ФизЛицо
			|					ИЗ
			|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|					ГДЕ
			|						ВЫБОР
			|							КОГДА &ЧерезКассуВключаяСотрудниковЧерезБанк
			|								ТОГДА ИСТИНА
			|							КОГДА &ЧерезКассу
			|								ТОГДА ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|							КОГДА &ЧерезБанк
			|								ТОГДА НЕ ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|						КОНЕЦ)) КАК ХозрасчетныйОстатки
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|		ПО ХозрасчетныйОстатки.Субконто1 = ВременнаяТаблицаСотрудники.ФизЛицо
			|ГДЕ
			|	ХозрасчетныйОстатки.СуммаОстатокКт > 0";
		
	// Обороты по счету 3520 для не уволенных
	// Остатки по счету 3520 для уволенных
	ИначеЕсли ВидЗаполнения = "ЗаполнитьПоОстаткамЗаМесяц" Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ХозрасчетныйОбороты.Субконто1 КАК ФизЛицо,
			|	ХозрасчетныйОбороты.СуммаОборотКт - ХозрасчетныйОбороты.СуммаОборотДт КАК СуммаКВыплате
			|ПОМЕСТИТЬ ВременнаяТаблицаРассчитанныеСуммы
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.Обороты(
			|			&НачалоПериода,
			|			&КонецПериода,
			|			,
			|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
			|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
			|			Организация = &Организация
			|				И Субконто1 В
			|					(ВЫБРАТЬ
			|						ВременнаяТаблицаСотрудники.ФизЛицо
			|					ИЗ
			|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|					ГДЕ
			|						ВЫБОР
			|							КОГДА &ЧерезКассуВключаяСотрудниковЧерезБанк
			|								ТОГДА ИСТИНА
			|							КОГДА &ЧерезКассу
			|								ТОГДА ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|							КОГДА &ЧерезБанк
			|								ТОГДА НЕ ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|						КОНЕЦ
			|						И НЕ ВременнаяТаблицаСотрудники.Уволен),
			|			,
			|			) КАК ХозрасчетныйОбороты
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|		ПО ХозрасчетныйОбороты.Субконто1 = ВременнаяТаблицаСотрудники.ФизЛицо
			|ГДЕ
			|	ХозрасчетныйОбороты.СуммаОборотКт - ХозрасчетныйОбороты.СуммаОборотДт > 0
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ХозрасчетныйОстатки.Субконто1,
			|	ХозрасчетныйОстатки.СуммаОстатокКт
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.Остатки(
			|			&КонецПериода,
			|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
			|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
			|			Организация = &Организация
			|				И Субконто1 В
			|					(ВЫБРАТЬ
			|						ВременнаяТаблицаСотрудники.ФизЛицо
			|					ИЗ
			|						ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|					ГДЕ
			|						ВЫБОР
			|							КОГДА &ЧерезКассуВключаяСотрудниковЧерезБанк
			|								ТОГДА ИСТИНА
			|							КОГДА &ЧерезКассу
			|								ТОГДА ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|							КОГДА &ЧерезБанк
			|								ТОГДА НЕ ВременнаяТаблицаСотрудники.Банк ЕСТЬ NULL
			|						КОНЕЦ
			|						И ВременнаяТаблицаСотрудники.Уволен)) КАК ХозрасчетныйОстатки
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
			|		ПО ХозрасчетныйОстатки.Субконто1 = ВременнаяТаблицаСотрудники.ФизЛицо
			|ГДЕ
			|	ХозрасчетныйОстатки.СуммаОстатокКт > 0";			
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации) + 1);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ЧерезКассуВключаяСотрудниковЧерезБанк", ВключаяСотрудниковЧерезБанк);
	Запрос.УстановитьПараметр("ЧерезКассу", ВидВыплаты = Перечисления.ВидыВыплатыЗарплаты.ЧерезКассу);
	Запрос.УстановитьПараметр("ЧерезБанк", ВидВыплаты = Перечисления.ВидыВыплатыЗарплаты.ЧерезБанк);
	Запрос.Выполнить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ВременнаяТаблицаРассчитанныеСуммы.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаСотрудники.Уволен,
		|	ВременнаяТаблицаРассчитанныеСуммы.СуммаКВыплате КАК СуммаКВыплате,
		|	ВременнаяТаблицаСотрудники.НомерЛицевогоСчета,
		|	ВременнаяТаблицаСотрудники.Подразделение КАК Подразделение,
		|	ЗНАЧЕНИЕ(Перечисление.ВыплаченностьЗарплаты.Выплачено) КАК ВыплаченностьЗарплаты
		|ИЗ
		|	ВременнаяТаблицаРассчитанныеСуммы КАК ВременнаяТаблицаРассчитанныеСуммы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСотрудники КАК ВременнаяТаблицаСотрудники
		|		ПО ВременнаяТаблицаРассчитанныеСуммы.ФизЛицо = ВременнаяТаблицаСотрудники.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизЛицо.Наименование";
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТабличнойЧасти = Зарплата.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
		
		Если ВыборкаДетальныеЗаписи.Уволен Тогда 
			Продолжить;
		КонецЕсли;
		
		// Округление
		СтрокаТабличнойЧасти.СуммаКВыплате = БухгалтерскийУчетСервер.ОкруглитьЦену(СтрокаТабличнойЧасти.СуммаКВыплате, ПорядокОкругления, Истина);
	КонецЦикла;
	
	МенеджерВременныхТаблиц.Закрыть();
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли