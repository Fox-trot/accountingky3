﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПериодРегистрации = НачалоМесяца(ТекущаяДатаСеанса());
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ПериодРегистрации", "МесяцСтрокой");
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы ОбработкаВыбора
//
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма")
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
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", , Отказ);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран период регистрации!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПериодРегистрации", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	

	СформироватьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
// Функция формирует и выполняет запрос.
//
Функция ВыполнитьЗапрос()
	
	// 1. Сведения о сотруднике, остатки
	// 2. Начисления 
	// 3. Удеражания, налоги
	// 3. Выплаты
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы,
		|	СУММА(ДанныеПроизводственногоКалендаря.ЗначениеДней) КАК НормаДней,
		|	СУММА(ДанныеПроизводственногоКалендаря.ЗначениеЧасов) КАК НормаЧасов
		|ПОМЕСТИТЬ ВременнаяТаблицаГрафики
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.Год = ГОД(&НачалоПериода)
		|	И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
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
		|	ЕСТЬNULL(ДолгНаНачало.СуммаОстатокДт, 0) * -1 + ЕСТЬNULL(ДолгНаНачало.СуммаОстатокКт, 0) КАК СальдоНаНачало,
		|	СтатусыСотрудниковСрезПоследних.Статус КАК Статус,
		|	СтавкиНалоговЗаработнойПлатыСрезПоследних.Вычеты * 100 КАК Вычеты,
		|	ВременнаяТаблицаГрафики.НормаДней,
		|	ВременнаяТаблицаГрафики.НормаЧасов
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
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыСотрудников.СрезПоследних(
		|				&КонецПериода,
		|				Организация = &Организация
		|					И ФизЛицо = &ФизЛицо) КАК СтатусыСотрудниковСрезПоследних
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНалоговЗаработнойПлаты.СрезПоследних(&КонецПериода, ) КАК СтавкиНалоговЗаработнойПлатыСрезПоследних
		|			ПО СтатусыСотрудниковСрезПоследних.Статус = СтавкиНалоговЗаработнойПлатыСрезПоследних.Статус
		|		ПО СотрудникиСрезПоследних.Организация = СтатусыСотрудниковСрезПоследних.Организация
		|			И СотрудникиСрезПоследних.ФизЛицо = СтатусыСотрудниковСрезПоследних.Физлицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаГрафики КАК ВременнаяТаблицаГрафики
		|		ПО СотрудникиСрезПоследних.ГрафикРаботы = ВременнаяТаблицаГрафики.ГрафикРаботы
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
		|	МАКСИМУМ(СальдоНаНачало),
		|	МАКСИМУМ(Статус),
		|	МАКСИМУМ(Вычеты),
		|	МАКСИМУМ(НормаДней),
		|	МАКСИМУМ(НормаЧасов)
		|ПО
		|	Подразделение,
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.ФизЛицо КАК ФизЛицо,
		|	Начисления.ВидРасчета КАК ВидРасчета,
		|	Начисления.ОтработаноДней КАК ОтработаноДней,
		|	Начисления.ОтработаноЧасов КАК ОтработаноЧасов,
		|	Начисления.Размер КАК Размер,
		|	Начисления.Результат КАК Сумма,
		|	Начисления.ПериодДействияНачало КАК ДатаНачала,
		|	Начисления.ПериодДействияКонец КАК ДатаОкончания,
		|	Начисления.ВидРасчета.РеквизитДопУпорядочивания КАК Порядок
		|ИЗ
		|	РегистрРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Начисления.Организация = &Организация
		|	И Начисления.ФизЛицо = &ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок
		|ИТОГИ
		|	СУММА(ОтработаноДней),
		|	СУММА(ОтработаноЧасов),
		|	СУММА(Сумма)
		|ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Удержания.ФизЛицо КАК ФизЛицо,
		|	Удержания.ВидРасчета КАК ВидРасчета,
		|	Удержания.Размер КАК Размер,
		|	Удержания.Результат КАК СуммаУдержано,
		|	Удержания.ВидРасчета.РеквизитДопУпорядочивания КАК Порядок
		|ИЗ
		|	РегистрРасчета.Удержания КАК Удержания
		|ГДЕ
		|	Удержания.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Удержания.Организация = &Организация
		|	И Удержания.ФизЛицо = &ФизЛицо
		|ИТОГИ
		|	СУММА(СуммаУдержано)
		|ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Удержано налогов"" КАК Группа,
		|	НалогиПоЗаработнойПлатеОбороты.ФизЛицо КАК ФизЛицо,
		|	НалогиПоЗаработнойПлатеОбороты.ВидНалога КАК ВидРасчета,
		|	НалогиПоЗаработнойПлатеОбороты.СуммаОборот КАК Сумма,
		|	НалогиПоЗаработнойПлатеОбороты.ВидНалога.РеквизитДопУпорядочивания КАК Порядок
		|ИЗ
		|	РегистрНакопления.НалогиПоЗаработнойПлате.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо
		|				И ВидНалога В (ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПФР), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ГНПФР), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПН), ЗНАЧЕНИЕ(ПланВидовРасчета.ВидыНалогов.ПрофВзнос))) КАК НалогиПоЗаработнойПлатеОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок
		|ИТОГИ
		|	СУММА(Сумма)
		|ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Выплачено"" КАК Группа,
		|	ВЫБОР
		|		КОГДА ВыплаченнаяЗарплатаОбороты.ВидВыплаты = ЗНАЧЕНИЕ(Перечисление.ВидыВыплатыЗарплаты.ЧерезКассу)
		|			ТОГДА ""Через кассу ""
		|		ИНАЧЕ ""С расч. счета ""
		|	КОНЕЦ КАК ПредставлениеДокумента,
		|	Ложь КАК ПризнакАванса,
		|	ВыплаченнаяЗарплатаОбороты.Регистратор.Номер КАК Номер,
		|	ВыплаченнаяЗарплатаОбороты.Регистратор.Дата КАК Дата,
		|	ВыплаченнаяЗарплатаОбороты.Регистратор КАК Регистратор,
		|	ВыплаченнаяЗарплатаОбороты.ФизЛицо КАК Физлицо,
		|	ВыплаченнаяЗарплатаОбороты.СуммаОборот КАК СуммаВыплаты
		|ИЗ
		|	РегистрНакопления.ВыплаченнаяЗарплата.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ФизЛицо = &ФизЛицо) КАК ВыплаченнаяЗарплатаОбороты
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
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Возврат РезультатЗапроса;

КонецФункции // ВыполнитьЗапрос()

&НаСервере
// Процедура формирует отчет.
//
Процедура СформироватьВыполнить()
	
	РезультатЗапроса = ВыполнитьЗапрос();

	Если РезультатЗапроса[1].Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Нет данных для формирования отчета!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	Макет = Отчеты.РасчетныйЛистокНовый.ПолучитьМакет("ПФ_MXL_РасчетныйЛисток");

	
	ОбластьШапка 				= Макет.ПолучитьОбласть("Шапка");
	//ОбластьЗаголовок 			= Макет.ПолучитьОбласть("Заголовок");
	ОбластьНачисленоУдержано 	= Макет.ПолучитьОбласть("НачисленоУдержано");
	ОбластьДетали 				= Макет.ПолучитьОбласть("Детали");
	ОбластьДоходыВыплачено 		= Макет.ПолучитьОбласть("ДоходыВыплачено");
	//ОбластьДеталиВыплаты 		= Макет.ПолучитьОбласть("ДеталиВыплаты");
	//ОбластьВсего 				= Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал 				= Макет.ПолучитьОбласть("Подвал");
	ОбластьПодпись 				= Макет.ПолучитьОбласть("Подпись");
	ОбластьОтбивка 				= Макет.ПолучитьОбласть("Отбивка");

	//ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	//ОбластьФизЛицо = Макет.ПолучитьОбласть("ФизЛицо");
	//ОбластьГруппа = Макет.ПолучитьОбласть("Группа");
	//ОбластьДетали = Макет.ПолучитьОбласть("Детали");
	ОбластьНалоги = Макет.ПолучитьОбласть("Налоги");
	ОбластьНалогиДетали = Макет.ПолучитьОбласть("НалогиДетали");
	//ОбластьСРаботника104 = Макет.ПолучитьОбласть("СРаботника104");
	//ОбластьУдержанияОсобые = Макет.ПолучитьОбласть("УдержанияОсобые");
	//ОбластьПрофВзнос = Макет.ПолучитьОбласть("ПрофВзнос");
	ОбластьКВыдаче = Макет.ПолучитьОбласть("КВыдаче");
		
	ТабличныйДокумент.Очистить();

	//ОбластьЗаголовок.Параметры.Заголовок = "Расчетные листки за " + Формат(ПериодРегистрации, "ДФ =""ММММ гггг 'г.'""" ); 

	//ОбластьФизЛицо.Параметры.Дата = Формат(ПериодРегистрации , "ДФ=""ММММ гггг 'г.' """);
	//ТабличныйДокумент.Вывести(ОбластьОтбивка);

	Если ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям") Тогда 
    	ОбластьОтбивка.Параметры.ТекстОтбивки = "Организация: " + Организация;
		ТабличныйДокумент.Вывести(ОбластьОтбивка);
	КонецЕсли;	

	ВыборкаПодразделение = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Подразделение");
	Пока ВыборкаПодразделение.Следующий() Цикл

        ОбластьОтбивка.Параметры.ТекстОтбивки = "Подразделение: " + ВыборкаПодразделение.Подразделение;
		ТабличныйДокумент.Вывести(ОбластьОтбивка);
        ТабличныйДокумент.НачатьГруппуСтрок();
		
		ВыборкаФизлицо = ВыборкаПодразделение.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо");
		Пока ВыборкаФизлицо.Следующий() Цикл

			ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры,ВыборкаФизлицо);
			//ОбластьШапка.Параметры.Заполнить(ВыборкаФизлицо);

			ОбластьШапка.Параметры.Заголовок = "Расчетный листок за " + Формат(ПериодРегистрации , "ДФ=""ММММ гггг 'г.' """);
			ОбластьШапка.Параметры.Дата = Формат(ПериодРегистрации , "ДФ=""ММММ гггг 'г.' """);

			ПредставлениеФизЛицо = БухгалтерскийУчетСервер.ПолучитьФамилиюИмяОтчество(ВыборкаФизлицо.Фамилия, ВыборкаФизлицо.Имя, ВыборкаФизлицо.Отчество, Истина);
			ОбластьШапка.Параметры.ФизЛицо = ?(ЗначениеЗаполнено(ПредставлениеФизЛицо), ПредставлениеФизЛицо, ВыборкаФизлицо.Физлицо);
			
			ОбластьШапка.Параметры.ПерсВычет	= "Персональные вычеты";
			ОбластьШапка.Параметры.НормаД		= "Норма дней";
			
			Если ВыборкаФизлицо.СальдоНаНачало < 0 Тогда
				ОбластьШапка.Параметры.ДолгН = "Долг за работ-м на нач: " + ВыборкаФизлицо.СальдоНаНачало;
			Иначе	
				ОбластьШапка.Параметры.ДолгН = "Долг за орг-й на нач: " + ВыборкаФизлицо.СальдоНаНачало;
			КонецЕсли; 

			ТабличныйДокумент.Вывести(ОбластьШапка);
				
			//Начисление / удержание
			ВсегоНачисления = 0;
			ВсегоУдержания = 0;
			ВсегоНалоги = 0;
			СтруктураПоискиПоВыборкей = Новый Структура("Физлицо", ВыборкаФизлицо.Физлицо);
		
			ВыборкаДеталиНачисления = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо");			
			Пока ВыборкаДеталиНачисления.НайтиСледующий(СтруктураПоискиПоВыборкей) Цикл
				
				ЗаполнитьЗначенияСвойств(ОбластьНачисленоУдержано.Параметры,ВыборкаДеталиНачисления);
				ОбластьНачисленоУдержано.Параметры.Группа = "Начислено";
				ВсегоНачисления = ВыборкаДеталиНачисления.Сумма;
				ТабличныйДокумент.Вывести(ОбластьНачисленоУдержано);
				
				ВыборкаДетали = ВыборкаДеталиНачисления.Выбрать();
				Пока  ВыборкаДетали.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(ОбластьДетали.Параметры,ВыборкаДетали);
					ТабличныйДокумент.Вывести(ОбластьДетали); 
				КонецЦикла;
			КонецЦикла;
			
			ВыборкаДеталиУдержания = РезультатЗапроса[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо");
			Пока ВыборкаДеталиУдержания.НайтиСледующий(СтруктураПоискиПоВыборкей) Цикл
				
				ЗаполнитьЗначенияСвойств(ОбластьНачисленоУдержано.Параметры,ВыборкаДеталиУдержания);
				ОбластьНачисленоУдержано.Параметры.Группа = "Удержано";
				ВсегоУдержания = ВыборкаДеталиУдержания.Сумма;
				ТабличныйДокумент.Вывести(ОбластьНачисленоУдержано);
				
				ВыборкаДетали = ВыборкаДеталиУдержания.Выбрать();
				Пока  ВыборкаДетали.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(ОбластьДетали.Параметры,ВыборкаДетали);
					ТабличныйДокумент.Вывести(ОбластьДетали); 
				КонецЦикла;
			КонецЦикла;	
						
			ВыборкаДеталиУдержания = РезультатЗапроса[4].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФизЛицо");
			Пока ВыборкаДеталиУдержания.НайтиСледующий(СтруктураПоискиПоВыборкей) Цикл
				
				ЗаполнитьЗначенияСвойств(ОбластьНалоги.Параметры,ВыборкаДеталиУдержания);
				ОбластьНалоги.Параметры.Группа = "Удержано налогов";
				ВсегоНалоги = ВыборкаДеталиУдержания.Сумма;
				ТабличныйДокумент.Вывести(ОбластьНалоги);
				
				ВыборкаДетали = ВыборкаДеталиУдержания.Выбрать();
				Пока  ВыборкаДетали.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(ОбластьНалогиДетали.Параметры,ВыборкаДетали);
					ТабличныйДокумент.Вывести(ОбластьНалогиДетали); 
				КонецЦикла;
			КонецЦикла;		
			
			ЗП =  ВсегоНачисления - ВсегоУдержания - ВсегоНалоги;
			Если ЗП <> 0 Тогда 
				ОбластьКВыдаче.Параметры.Группа = "Зарплата за месяц";
				ОбластьКВыдаче.Параметры.КВыдаче = ЗП;
				ТабличныйДокумент.Вывести(ОбластьКВыдаче);
			КонецЕсли;
			
			// Выплачено
			Если Не РезультатЗапроса[5].Пустой() Тогда 
				
				ВыборкаВыплатСотрудника		= РезультатЗапроса[5].Выбрать();

				ОбластьДоходыВыплачено.Параметры.Группа = "Выплачено:";
				ТабличныйДокумент.Вывести(ОбластьДоходыВыплачено);
				Пока ВыборкаВыплатСотрудника.НайтиСледующий(СтруктураПоискиПоВыборкей) Цикл			
					//ОбластьКВыдаче.Параметры.Заполнить(ВыборкаВыплатСотрудника);
					ОбластьКВыдаче.Параметры.Группа = "" + ВыборкаВыплатСотрудника.ПредставлениеДокумента + ?(ВыборкаВыплатСотрудника.ПризнакАванса, "(аванс) №", " №") + 
					СокрЛП(ВыборкаВыплатСотрудника.Номер) + " от " + Формат(ВыборкаВыплатСотрудника.Дата, "ДФ=dd.MM.yyyy");
					ОбластьКВыдаче.Параметры.КВыдаче =  ВыборкаВыплатСотрудника.СуммаВыплаты;
					ТабличныйДокумент.Вывести(ОбластьКВыдаче);			
				КонецЦикла;
			
		КонецЕсли;
					
			//Если ВыборкаФизлицо.СальдоНаКонец < 0 Тогда
			//	ОбластьПодвал.Параметры.ДолгК = "Долг за работ-м на кон: " + ВыборкаФизлицо.СальдоНаКонец;
			//Иначе	
			//	ОбластьПодвал.Параметры.ДолгК = "Долг за орг-й на кон: " + ВыборкаФизлицо.СальдоНаКонец;
			//КонецЕсли; 
			
			ОбластьПодвал.Параметры.ДолгК = "Итого к выплате: " + ВыборкаФизлицо.СальдоНаКонец;
			ТабличныйДокумент.Вывести(ОбластьПодвал);
			
			Если ВывестиПодпись Тогда
				ТабличныйДокумент.Вывести(ОбластьПодпись);		
			КонецЕсли;
			
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
