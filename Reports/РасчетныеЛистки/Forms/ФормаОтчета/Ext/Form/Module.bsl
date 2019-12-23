﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодРегистрации = НачалоМесяца(ТекущаяДатаСеанса());
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ПериодРегистрации", "МесяцСтрокой");
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы ОбработкаВыбора
//
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("ФормаКлиентскогоПриложения")
		И СтрНайти(ИсточникВыбора.ИмяФормы, "ФормаКалендаря") > 0 Тогда
		
		ПериодРегистрации = КонецДня(ВыбранноеЗначение);
		БухгалтерскийУчетКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаВыбора()

&НаСервере
// Процедура - обработчик события формы ПриСохраненииПользовательскихНастроекНаСервере
//
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик команды Сформировать.
//
Процедура Сформировать(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана организация!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Организация", , Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран период регистрации!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ПериодРегистрации", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	

	СформироватьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Функция формирует и выполняет запрос.
//
Функция ВыполнитьЗапрос()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыНачислений.Ссылка КАК ВидРасчета
		|ИЗ
		|	ПланВидовРасчета.ВидыНачислений КАК ВидыНачислений
		|ГДЕ
		|	ВидыНачислений.СпособРасчета = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаНачислений.Неявка)";
	ВидыРасчетовИсключения = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидРасчета");
	
	// 1. Сведения о сотруднике, остатки
	// 2. Начисления, удеражания, налоги
	// 3. Выплаты
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизЛицо КАК ФизЛицо,
		|	СотрудникиСрезПоследних.ФизЛицо.Код КАК ТабельныйНомер,
		|	СотрудникиСрезПоследних.Подразделение КАК Подразделение,
		|	СотрудникиСрезПоследних.Подразделение.Наименование КАК ПодразделениеПредставление,
		|	СотрудникиСрезПоследних.Должность КАК Должность,
		|	ФИОФизическихЛицСрезПоследних.Фамилия КАК Фамилия,
		|	ФИОФизическихЛицСрезПоследних.Имя КАК Имя,
		|	ФИОФизическихЛицСрезПоследних.Отчество КАК Отчество,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ФИОФизическихЛицСрезПоследних.Фамилия, """") <> """"
		|			ТОГДА ФИОФизическихЛицСрезПоследних.Фамилия + "" "" + ФИОФизическихЛицСрезПоследних.Имя + "" "" + ФИОФизическихЛицСрезПоследних.Отчество
		|		ИНАЧЕ СотрудникиСрезПоследних.ФизЛицо.Наименование
		|	КОНЕЦ КАК СотрудникПредставление,
		|	ЕСТЬNULL(ДолгНаКонец.СуммаОстатокДт, 0) * -1 + ЕСТЬNULL(ДолгНаКонец.СуммаОстатокКт, 0) КАК СальдоНаКонец,
		|	ЕСТЬNULL(ДолгНаНачало.СуммаОстатокДт, 0) * -1 + ЕСТЬNULL(ДолгНаНачало.СуммаОстатокКт, 0) КАК СальдоНаНачало
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&КонецПериода,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо) КАК СотрудникиСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&КонецПериода, ) КАК ФИОФизическихЛицСрезПоследних
		|		ПО СотрудникиСрезПоследних.ФизЛицо = ФИОФизическихЛицСрезПоследних.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&НачалоПериода,
		|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
		|				Организация = &Организация
		|					И Субконто1 = &ФизЛицо) КАК ДолгНаНачало
		|		ПО СотрудникиСрезПоследних.Организация = ДолгНаНачало.Организация
		|			И СотрудникиСрезПоследних.ФизЛицо = ДолгНаНачало.Субконто1
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				ДОБАВИТЬКДАТЕ(&КонецПериода, СЕКУНДА, 1),
		|				Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СотрудникиОрганизаций),
		|				Организация = &Организация
		|					И Субконто1 = &ФизЛицо) КАК ДолгНаКонец
		|		ПО СотрудникиСрезПоследних.Организация = ДолгНаКонец.Организация
		|			И СотрудникиСрезПоследних.ФизЛицо = ДолгНаКонец.Субконто1
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение В ИЕРАРХИИ(&Подразделение)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПодразделениеПредставление,
		|	СотрудникПредставление
		|ИТОГИ
		|	МАКСИМУМ(ПодразделениеПредставление),
		|	МАКСИМУМ(Должность),
		|	МАКСИМУМ(Фамилия),
		|	МАКСИМУМ(Имя),
		|	МАКСИМУМ(Отчество),
		|	МАКСИМУМ(СальдоНаКонец),
		|	МАКСИМУМ(СальдоНаНачало)
		|ПО
		|	Подразделение,
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.ФизЛицо КАК ФизЛицо,
		|	Начисления.ВидРасчета КАК Начисление,
		|	NULL КАК Удержание,
		|	Начисления.ОтработаноДней КАК ОтработаноДней,
		|	Начисления.ОтработаноЧасов КАК ОтработаноЧасов,
		|	Начисления.Размер КАК Размер,
		|	ВЫБОР
		|		КОГДА Начисления.ВидРасчета.ДополнительныйДоход
		|			ТОГДА 0
		|		ИНАЧЕ Начисления.Результат
		|	КОНЕЦ КАК СуммаНачислено,
		|	ВЫБОР
		|		КОГДА Начисления.ВидРасчета.ДополнительныйДоход
		|			ТОГДА Начисления.Результат
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Допдоход,
		|	0 КАК СуммаУдержано,
		|	Начисления.ПериодДействияНачало КАК ДатаНачала,
		|	Начисления.ПериодДействияКонец КАК ДатаОкончания
		|ИЗ
		|	РегистрРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Начисления.Организация = &Организация
		|	И Начисления.ФизЛицо = &ФизЛицо
		|	И НЕ Начисления.ВидРасчета В (&ВидыРасчетовИсключения)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Удержания.ФизЛицо,
		|	NULL,
		|	Удержания.ВидРасчета,
		|	0,
		|	0,
		|	Удержания.Размер,
		|	0,
		|	0,
		|	Удержания.Результат,
		|	NULL,
		|	Удержания.ПериодРегистрации
		|ИЗ
		|	РегистрРасчета.Удержания КАК Удержания
		|ГДЕ
		|	Удержания.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Удержания.Организация = &Организация
		|	И Удержания.ФизЛицо = &ФизЛицо
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НалогиПоЗаработнойПлатеОбороты.ФизЛицо,
		|	NULL,
		|	НалогиПоЗаработнойПлатеОбороты.ВидНалога,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	НалогиПоЗаработнойПлатеОбороты.СуммаОборот,
		|	NULL,
		|	NULL
		|ИЗ
		|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И ВидНалога В (ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФР), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ГНПФР), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПН), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПрофВзнос))) КАК НалогиПоЗаработнойПлатеОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ВыплаченнаяЗарплатаОбороты.ВидВыплаты = ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезКассу)
		|			ТОГДА ""Через кассу ""
		|		ИНАЧЕ ""С расч. счета ""
		|	КОНЕЦ КАК ПредставлениеДокумента,
		|	ВЫБОР
		|		КОГДА ВыплаченнаяЗарплатаОбороты.ПериодРегистрации = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПризнакАванса,
		|	ДанныеПервичныхДокументов.Номер КАК Номер,
		|	ДанныеПервичныхДокументов.Дата КАК Дата,
		|	ВыплаченнаяЗарплатаОбороты.ПериодРегистрации КАК ПериодРегистрации,
		|	ВыплаченнаяЗарплатаОбороты.Регистратор КАК Регистратор,
		|	ВыплаченнаяЗарплатаОбороты.ФизЛицо КАК ФизЛицо,
		|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК СуммаВыплаты
		|ИЗ
		|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо) КАК ВыплаченнаяЗарплатаОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
		|		ПО ВыплаченнаяЗарплатаОбороты.Организация = ДанныеПервичныхДокументов.Организация
		|			И ВыплаченнаяЗарплатаОбороты.Регистратор = ДанныеПервичныхДокументов.Документ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
		
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СотрудникиСрезПоследних.Подразделение В ИЕРАРХИИ (&Подразделение)", "ИСТИНА");	
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Начисления.ФизЛицо = &ФизЛицо", "ИСТИНА");	
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Удержания.ФизЛицо = &ФизЛицо", "ИСТИНА");	
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Субконто1 = &ФизЛицо", "ИСТИНА");	
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ФизЛицо = &ФизЛицо", "ИСТИНА");	
	КонецЕсли;	
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НачалоПериода", ПериодРегистрации);	
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ФизЛицо", Сотрудник);
	Запрос.УстановитьПараметр("ВидыРасчетовИсключения", ВидыРасчетовИсключения);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Возврат РезультатЗапроса;

КонецФункции // ВыполнитьЗапрос()

&НаСервере
// Процедура формирует отчет.
//
Процедура СформироватьВыполнить()
	
	РезультатЗапроса = ВыполнитьЗапрос();

	Если РезультатЗапроса[0].Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Нет данных для формирования отчета!'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	Макет = Отчеты.РасчетныеЛистки.ПолучитьМакет("Макет");

	ОбластьШапка 				= Макет.ПолучитьОбласть("Шапка");
	ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьНачисленоУдержано 	= Макет.ПолучитьОбласть("НачисленоУдержано");
	ОбластьДетали 				= Макет.ПолучитьОбласть("Детали");
	ОбластьДопдоход 			= Макет.ПолучитьОбласть("Допдоход");
	ОбластьДеталиДопдоход 		= Макет.ПолучитьОбласть("ДеталиДопдоход");
	ОбластьДоходыВыплачено 		= Макет.ПолучитьОбласть("ДоходыВыплачено");
	ОбластьДеталиВыплаты 		= Макет.ПолучитьОбласть("ДеталиВыплаты");
	ОбластьВсего 				= Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал 				= Макет.ПолучитьОбласть("Подвал");
	ОбластьОтбивка 				= Макет.ПолучитьОбласть("Отбивка");

	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.АвтоМасштаб = Истина;

    ОбластьОтбивка.Параметры.ТекстОтбивки = Формат(ПериодРегистрации , "ДФ=""ММММ гггг 'г.' """);
	ТабличныйДокумент.Вывести(ОбластьОтбивка);

	Если ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям") Тогда 
    	ОбластьОтбивка.Параметры.ТекстОтбивки = "Организация: " + Организация;
		ТабличныйДокумент.Вывести(ОбластьОтбивка);
	КонецЕсли;	

	ТаблицаНачисленоУдержано = РезультатЗапроса[1].Выгрузить();
	ТаблицаНачисленоУдержано.Индексы.Добавить("ФизЛицо");
	
	ТаблицаВыплачено = РезультатЗапроса[2].Выгрузить();
	ТаблицаВыплачено.Индексы.Добавить("ФизЛицо");
	
	ВыборкаПодразделение = РезультатЗапроса[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Подразделение");
	Пока ВыборкаПодразделение.Следующий() Цикл

        ОбластьОтбивка.Параметры.ТекстОтбивки = "Подразделение: " + ВыборкаПодразделение.Подразделение;
		ТабличныйДокумент.Вывести(ОбластьОтбивка);
        ТабличныйДокумент.НачатьГруппуСтрок();
		
		ВыборкаФизЛицо = ВыборкаПодразделение.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо");
		Пока ВыборкаФизЛицо.Следующий() Цикл

			ОбластьШапка.Параметры.Заголовок = "Расчетный листок за " + Формат(ПериодРегистрации , "ДФ=""ММММ гггг 'г.' """);
			ОбластьШапка.Параметры.Организация = Организация;
			ОбластьШапка.Параметры.Заполнить(ВыборкаФизЛицо);
			ПредставлениеФизЛицо = БухгалтерскийУчетСервер.ПолучитьФамилиюИмяОтчество(ВыборкаФизЛицо.Фамилия, ВыборкаФизЛицо.Имя, ВыборкаФизЛицо.Отчество, Истина);
			ОбластьШапка.Параметры.ФизЛицо = ?(ЗначениеЗаполнено(ПредставлениеФизЛицо), ПредставлениеФизЛицо, ВыборкаФизЛицо.ФизЛицо);
			ТабличныйДокумент.Вывести(ОбластьШапка);
			ТабличныйДокумент.Вывести(ОбластьЗаголовок);
			ТабличныйДокумент.Вывести(ОбластьНачисленоУдержано);

			ПоследнееНачисление = ТабличныйДокумент.ВысотаТаблицы;
			ПоследнееУдержание = ТабличныйДокумент.ВысотаТаблицы;
			
			// Начисление / удержание
			ВсегоНачисления = 0;
			ВсегоУдержания = 0;
			
			МассивТиповНачислений = Новый Массив;
			МассивТиповНачислений.Добавить(Тип("ПланВидовРасчетаСсылка.ВидыНачислений"));
			
			ТЗДопдоходы = Новый ТаблицаЗначений; 
			ТЗДопдоходы.Колонки.Добавить("Начисление", 		Новый ОписаниеТипов(МассивТиповНачислений));
			ТЗДопдоходы.Колонки.Добавить("ДатаНачала", 		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
			ТЗДопдоходы.Колонки.Добавить("ДатаОкончания", 	ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
			ТЗДопдоходы.Колонки.Добавить("ОтработаноДней", 	ОбщегоНазначения.ОписаниеТипаЧисло(7,2));
			ТЗДопдоходы.Колонки.Добавить("ОтработаноЧасов", ОбщегоНазначения.ОписаниеТипаЧисло(7,2));
			ТЗДопдоходы.Колонки.Добавить("Допдоход", 		ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
			
			СтруктураПоискиПоВыборкей = Новый Структура("ФизЛицо", ВыборкаФизЛицо.ФизЛицо);
			НайденныеСтроки = ТаблицаНачисленоУдержано.НайтиСтроки(СтруктураПоискиПоВыборкей);
			
			Для Каждого НайденнаяСтрокаНачислениеУдержание Из НайденныеСтроки Цикл 
			
				Если НайденнаяСтрокаНачислениеУдержание.Удержание = NULL Тогда
					
					Если НайденнаяСтрокаНачислениеУдержание.СуммаНачислено <> 0 Тогда
					
						Если ПоследнееНачисление < ПоследнееУдержание Тогда
							
							ТабличныйДокумент.Область(ПоследнееНачисление + 1, 1).Текст = НайденнаяСтрокаНачислениеУдержание.Начисление;
							ТабличныйДокумент.Область(ПоследнееНачисление + 1, 2, ПоследнееНачисление + 1, 3).Текст = "" + День(НайденнаяСтрокаНачислениеУдержание.ДатаНачала) + "-" + День(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания) + " " + Формат(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания , "ДФ=""МММ гг""");
							ТабличныйДокумент.Область(ПоследнееНачисление + 1, 4).Текст = НайденнаяСтрокаНачислениеУдержание.ОтработаноДней;
							ТабличныйДокумент.Область(ПоследнееНачисление + 1, 5).Текст = НайденнаяСтрокаНачислениеУдержание.ОтработаноЧасов;
							ТабличныйДокумент.Область(ПоследнееНачисление + 1, 6, ПоследнееНачисление + 1, 7).Текст = НайденнаяСтрокаНачислениеУдержание.СуммаНачислено;
						
						Иначе
						
							ОбластьДетали.Параметры.Начисление = НайденнаяСтрокаНачислениеУдержание.Начисление;
							ОбластьДетали.Параметры.ПериодНачисление = "" + День(НайденнаяСтрокаНачислениеУдержание.ДатаНачала) + "-" + День(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания) + " " + Формат(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания , "ДФ=""МММ гг""");
							ОбластьДетали.Параметры.ОтработаноДнейНачисление = НайденнаяСтрокаНачислениеУдержание.ОтработаноДней;
							ОбластьДетали.Параметры.ОтработаноЧасовНачисление = НайденнаяСтрокаНачислениеУдержание.ОтработаноЧасов;
							ОбластьДетали.Параметры.СуммаНачисление = НайденнаяСтрокаНачислениеУдержание.СуммаНачислено;
							
							ТабличныйДокумент.Вывести(ОбластьДетали);
							
							ОбластьДетали.Параметры.Начисление = ПланыВидовРасчета.ВидыНачислений.ПустаяСсылка();
							ОбластьДетали.Параметры.ПериодНачисление = "";
							ОбластьДетали.Параметры.ОтработаноДнейНачисление = 0;
							ОбластьДетали.Параметры.ОтработаноЧасовНачисление = 0;
							ОбластьДетали.Параметры.СуммаНачисление = 0;
						
						КонецЕсли; 
						
						ПоследнееНачисление = ПоследнееНачисление + 1;
						
					Иначе
						СтрокаТаблицы = ТЗДопдоходы.Добавить();
						СтрокаТаблицы.Начисление 		= НайденнаяСтрокаНачислениеУдержание.Начисление;
						СтрокаТаблицы.ДатаНачала 		= НайденнаяСтрокаНачислениеУдержание.ДатаНачала;
						СтрокаТаблицы.ДатаОкончания 	= НайденнаяСтрокаНачислениеУдержание.ДатаОкончания;
						СтрокаТаблицы.ОтработаноДней 	= НайденнаяСтрокаНачислениеУдержание.ОтработаноДней;
						СтрокаТаблицы.ОтработаноЧасов 	= НайденнаяСтрокаНачислениеУдержание.ОтработаноЧасов;
						СтрокаТаблицы.Допдоход 			= НайденнаяСтрокаНачислениеУдержание.Допдоход;
					КонецЕсли;
					
				Иначе
					
					Если ПоследнееУдержание < ПоследнееНачисление Тогда
					
						ТабличныйДокумент.Область(ПоследнееУдержание + 1, 8, ПоследнееУдержание + 1, 10).Текст = НайденнаяСтрокаНачислениеУдержание.Удержание;	
						ТабличныйДокумент.Область(ПоследнееУдержание + 1, 11, ПоследнееУдержание + 1, 12).Текст = Формат(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания , "ДФ=""МММ гг""");
						ТабличныйДокумент.Область(ПоследнееУдержание + 1, 13, ПоследнееУдержание + 1, 14).Текст = НайденнаяСтрокаНачислениеУдержание.СуммаУдержано;
					
					Иначе
					
						ОбластьДетали.Параметры.Удержание = НайденнаяСтрокаНачислениеУдержание.Удержание;
						ОбластьДетали.Параметры.ПериодУдержание = Формат(НайденнаяСтрокаНачислениеУдержание.ДатаОкончания , "ДФ=""МММ гг""");
						ОбластьДетали.Параметры.СуммаУдержание = НайденнаяСтрокаНачислениеУдержание.СуммаУдержано;
						
						ТабличныйДокумент.Вывести(ОбластьДетали);
						
						ОбластьДетали.Параметры.Удержание = ПланыВидовРасчета.ВидыУдержаний.ПустаяСсылка();
						ОбластьДетали.Параметры.ПериодУдержание = "";
						ОбластьДетали.Параметры.СуммаУдержание = 0;
					
					КонецЕсли; 
					
					ПоследнееУдержание = ПоследнееУдержание + 1;
				
				КонецЕсли; 
				
				ВсегоНачисления = ВсегоНачисления + НайденнаяСтрокаНачислениеУдержание.СуммаНачислено;
				ВсегоУдержания = ВсегоУдержания + НайденнаяСтрокаНачислениеУдержание.СуммаУдержано;
			КонецЦикла;

			ТабличныйДокумент.Вывести(ОбластьДопдоход);
			
			// Вывести дополнительный доход.
			Для Каждого СтрокаТаблицы Из ТЗДопдоходы Цикл
				
				ОбластьДеталиДопдоход.Параметры.Начисление = СтрокаТаблицы.Начисление;
				ОбластьДеталиДопдоход.Параметры.ПериодНачисление = "" + День(СтрокаТаблицы.ДатаНачала) + "-" + День(СтрокаТаблицы.ДатаОкончания) + " " + Формат(СтрокаТаблицы.ДатаОкончания , "ДФ=""МММ гг""");
				ОбластьДеталиДопдоход.Параметры.ОтработаноДнейНачисление = СтрокаТаблицы.ОтработаноДней;
				ОбластьДеталиДопдоход.Параметры.ОтработаноЧасовНачисление = СтрокаТаблицы.ОтработаноЧасов;
				ОбластьДеталиДопдоход.Параметры.СуммаНачисление = СтрокаТаблицы.Допдоход;
				
				ТабличныйДокумент.Вывести(ОбластьДеталиДопдоход);
				
				ОбластьДеталиДопдоход.Параметры.Начисление = ПланыВидовРасчета.ВидыНачислений.ПустаяСсылка();
				ОбластьДеталиДопдоход.Параметры.ПериодНачисление = "";
				ОбластьДеталиДопдоход.Параметры.ОтработаноДнейНачисление = 0;
				ОбластьДеталиДопдоход.Параметры.ОтработаноЧасовНачисление = 0;
				ОбластьДеталиДопдоход.Параметры.СуммаНачисление = 0;
				
				//ВсегоНачисления = ВсегоНачисления + СтрокаТаблицы.Допдоход;
			КонецЦикла;	
			
			ОбластьВсего.Параметры.ВсегоНачисления = ВсегоНачисления;
			ОбластьВсего.Параметры.ВсегоУдержания = ВсегоУдержания;
			ТабличныйДокумент.Вывести(ОбластьВсего);
			
			// Выплачено
			ТабличныйДокумент.Вывести(ОбластьДоходыВыплачено);
			//ВыборкаВыплатСотрудника = РезультатЗапроса[2].Выбрать();
			
			СтруктураПоискиПоВыборкей = Новый Структура("ФизЛицо", ВыборкаФизЛицо.ФизЛицо);
			НайденныеСтроки = ТаблицаВыплачено.НайтиСтроки(СтруктураПоискиПоВыборкей);
			
			Для Каждого НайденнаяСтрокаВыплачено Из НайденныеСтроки Цикл
				
				ОбластьДеталиВыплаты.Параметры.Заполнить(НайденнаяСтрокаВыплачено);
				ОбластьДеталиВыплаты.Параметры.ТекстВыплаты = "" + НайденнаяСтрокаВыплачено.ПредставлениеДокумента 
					+ ?(НайденнаяСтрокаВыплачено.ПризнакАванса, "(аванс) №", " №") + 
					СокрЛП(НайденнаяСтрокаВыплачено.Номер) + " от " + Формат(НайденнаяСтрокаВыплачено.Дата, "ДЛФ=D");
					
				Если НайденнаяСтрокаВыплачено.ПризнакАванса Тогда 
					ОбластьДеталиВыплаты.Параметры.ПериодВыплат = Формат(НайденнаяСтрокаВыплачено.Дата, "ДФ=""МММ гг""");
				Иначе 
					ОбластьДеталиВыплаты.Параметры.ПериодВыплат = Формат(НайденнаяСтрокаВыплачено.ПериодРегистрации, "ДФ=""МММ гг""");
				КонецЕсли;	
				
				ТабличныйДокумент.Вывести(ОбластьДеталиВыплаты);
				
			КонецЦикла;
			
			Если ВыборкаФизЛицо.СальдоНаНачало < 0 Тогда
				ОбластьПодвал.Параметры.ТекстДолгНаНачалоПериода = "Долг за работником на начало месяца:";
				СальдоНаНачало = ВыборкаФизЛицо.СальдоНаНачало * (-1);
			Иначе	
				ОбластьПодвал.Параметры.ТекстДолгНаНачалоПериода = "Долг за организацией на начало месяца:";
				СальдоНаНачало = ВыборкаФизЛицо.СальдоНаНачало;
			КонецЕсли; 
			
			Если ВыборкаФизЛицо.СальдоНаКонец < 0 Тогда
				ОбластьПодвал.Параметры.ТекстДолгНаКонецПериода = "Долг за работником на конец месяца:";
				СальдоНаКонец = ВыборкаФизЛицо.СальдоНаКонец * (-1);
			Иначе	
				ОбластьПодвал.Параметры.ТекстДолгНаКонецПериода = "Долг за организацией на конец месяца:";
				СальдоНаКонец = ВыборкаФизЛицо.СальдоНаКонец;
			КонецЕсли;
			
			ОбластьПодвал.Параметры.СуммаДолгНаНачалоПериода = СальдоНаНачало;
			ОбластьПодвал.Параметры.СуммаДолгНаКонецПериода = СальдоНаКонец;

			ТабличныйДокумент.Вывести(ОбластьПодвал);
			
		КонецЦикла;

        ТабличныйДокумент.ЗакончитьГруппуСтрок();
	КонецЦикла;	

КонецПроцедуры // Сформировать()

#КонецОбласти

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "ПериодРегистрации", "МесяцСтрокой");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПериодРегистрации.
//
&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "ПериодРегистрации", "МесяцСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти
