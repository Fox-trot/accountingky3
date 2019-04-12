﻿
#Область ОбработчикиСобытийФормы

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
	
	Если Параметры.Свойство("ДатаНачала") И Параметры.Свойство("ДатаОкончания") Тогда
		ДатаНачала 		= Параметры.ДатаНачала;
		ДатаОкончания 	= Параметры.ДатаОкончания;
	Иначе
		Дата = ТекущаяДатаСеанса();		
		ДатаНачала 		= НачалоМесяца(Дата);
		ДатаОкончания 	= КонецМесяца(Дата);
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда 
		Организация = Параметры.Организация;
	Иначе                            
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ПустаяВалюта = Справочники.Валюты.ПустаяСсылка();
	ТипЗначенияКасса = ТипЗнч(Справочники.Кассы.ПустаяСсылка());
	ТипЗначенияБанковскийСчет = ТипЗнч(Справочники.БанковскиеСчета.ПустаяСсылка());
	СчетаНКР.Добавить(ПланыСчетов.Хозрасчетный.ДоходОтКурсовыхРазницПоОперациямВИностраннойВалюте);
	СчетаНКР.Добавить(ПланыСчетов.Хозрасчетный.УбыткиОтКурсовыхРазницПоОперациямВИностраннойВалюте);
	СчетаОКР.Добавить(ПланыСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц);
	СчетаОКР.Добавить(ПланыСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц);
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ДатаОкончания = КонецМесяца(ДатаНачала);
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ДатаНачала = НачалоМесяца(ДатаОкончания);
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура СтраницыОбработкиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновитьДанные();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	УстановитьПараметрыДинамическихСписков();
	ОбновитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура Расшифровка(Команда)
	Элементы.ТаблицаОКРРасшифровка.Пометка = Не Элементы.ТаблицаОКРРасшифровка.Пометка;
	ПроверитьРасшифровкуПоОКР();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()

	Элементы.РасшифровкаПоОКР.Видимость = Элементы.ТаблицаОКРРасшифровка.Пометка;	

КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

// Процедура установки значений параметров динамических списков.
//
// Параметры:
//	ИзменилосьОС - Булево - проверка изменения значения реквизита "ОсновноеСредство".
//
&НаКлиенте
Процедура УстановитьПараметрыДинамическихСписков()

	ТекущаяСтрокаОСВ = Элементы.СписокОСВ.ТекущиеДанные;
	// СписокОСВ
	СписокОСВ.Параметры.УстановитьЗначениеПараметра("НачалоПериода", ДатаНачала);
	СписокОСВ.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецДня(ДатаОкончания));
	СписокОСВ.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	СписокОСВ.Параметры.УстановитьЗначениеПараметра("ПустаяВалюта", ПустаяВалюта);
	СписокОСВ.Параметры.УстановитьЗначениеПараметра("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	
	Если ТекущаяСтрокаОСВ <> Неопределено Тогда
		// ДокументыНКР
		ДокументыНКР.Параметры.УстановитьЗначениеПараметра("НачалоПериода", ДатаНачала);
		ДокументыНКР.Параметры.УстановитьЗначениеПараметра("КонецПериода", КонецДня(ДатаОкончания) - 1);
		ДокументыНКР.Параметры.УстановитьЗначениеПараметра("Организация", Организация);
		ДокументыНКР.Параметры.УстановитьЗначениеПараметра("Субконто1", ТекущаяСтрокаОСВ.Субконто1);
		ДокументыНКР.Параметры.УстановитьЗначениеПараметра("Субконто2", ТекущаяСтрокаОСВ.Субконто2);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуНКР()
	
	СводнаяТаблицаПереоценки = ПолучитьСводнуюТаблицуПереоценки();
	
	ТаблицаНКР.Загрузить(СводнаяТаблицаПереоценки);
	
	Переоценка = 0; 
	
	Для Каждого СтрокаТабличнойЧасти Из ТаблицаНКР Цикл
		Комментарий = "";
			
		Если СтрокаТабличнойЧасти.ВалютнаяСуммаНачальныйОстаток = Null Тогда 
			СтрокаТабличнойЧасти.ВалютнаяСуммаНачальныйОстаток = 0;
		КонецЕсли;			
		Если СтрокаТабличнойЧасти.ВалютнаяСуммаКонечныйОстаток = Null Тогда 
			СтрокаТабличнойЧасти.ВалютнаяСуммаКонечныйОстаток = 0;
		КонецЕсли;			
		
		//СтрокаТабличнойЧасти.ВалютнаяСуммаНачальныйОстаток = СтрокаТабличнойЧасти.ВалютнаяСуммаКонечныйОстаток;
		//СтрокаТабличнойЧасти.СуммаНачальныйОстаток = СтрокаТабличнойЧасти.СуммаКонечныйОстаток;
		
		СтрокаТабличнойЧасти.КурсНБ 	= РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаОкончания).Курс;
		СтрокаТабличнойЧасти.СальдоНБ	= Окр(СтрокаТабличнойЧасти.ВалютнаяСуммаКонечныйОстаток * СтрокаТабличнойЧасти.КурсНБ, 2);
		
		СтрокаТабличнойЧасти.Регистратор = "Закрытие месяца от " + Формат(ДатаОкончания, "ДФ=dd.MM.yyyy");
		
		СтрокаТабличнойЧасти.Комментарий = "" + СтрокаТабличнойЧасти.Счет + "-" + Валюта + "-" + Субконто1 + ?(ЗначениеЗаполнено(Договор), "-" + Договор, "");
		
		Если СтрокаТабличнойЧасти.Содержание <> "Закрытие парных счетов" Тогда
			Переоценка = Переоценка + ?(СтрокаТабличнойЧасти.Результат = "Расход", -СтрокаТабличнойЧасти.Переоценка, СтрокаТабличнойЧасти.Переоценка);		
		ИначеЕсли СтрокаТабличнойЧасти.Содержание = "Закрытие парных счетов" Тогда
			СтрокаТабличнойЧасти.Переоценка = Переоценка;	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // СформироватьТаблицуНКР()

&НаСервере
Функция ПолучитьСводнуюТаблицуПереоценки()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаНачальныйОстаток КАК ВалютнаяСуммаНачальныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстаток КАК СуммаНачальныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт КАК ВалютнаяСуммаОборотДт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК СуммаОборотДт,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт КАК ВалютнаяСуммаОборотКт,
	|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК СуммаОборотКт,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаКонечныйОстаток КАК ВалютнаяСуммаКонечныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстаток КАК СуммаКонечныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.Период КАК Дата,
	|	ХозрасчетныйДвиженияССубконто.Сумма КАК Переоценка,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт1 КАК СубконтоДт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК СубконтоКт1,
	|	ХозрасчетныйДвиженияССубконто.СчетДт КАК СчетДт,
	|	ХозрасчетныйДвиженияССубконто.СчетКт КАК СчетКт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт2 КАК СубконтоДт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт2 КАК СубконтоКт2,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ХозрасчетныйДвиженияССубконто.Содержание, 1, 5) = ""Доход""
	|			ТОГДА ""Доход""
	|		КОГДА ПОДСТРОКА(ХозрасчетныйДвиженияССубконто.Содержание, 1, 6) = ""Убытки""
	|			ТОГДА ""Расход""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Результат,
	|	ХозрасчетныйОстаткиИОбороты.Счет КАК Счет,
	|	""Курсовая разница"" КАК Содержание
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			,
	|			Счет = &Счет
	|				ИЛИ Счет = &ПарныйСчет,
	|			,
	|			Субконто1 = &Субконто1) КАК ХозрасчетныйОстаткиИОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	|				&НачалоПериода,
	|				&КонецПериодаНКР,
	|				Счет В (&СчетаНКР)
	|					И (СубконтоКт1 = &Субконто1
	|						ИЛИ СубконтоДт1 = &Субконто1),
	|				,
	|				) КАК ХозрасчетныйДвиженияССубконто
	|		ПО (ХозрасчетныйОстаткиИОбороты.Счет = ХозрасчетныйДвиженияССубконто.СчетДт
	|				ИЛИ ХозрасчетныйОстаткиИОбороты.Счет = ХозрасчетныйДвиженияССубконто.СчетКт)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаКонечныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстаток,
	|	ХозрасчетныйОстаткиИОбороты.Период,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ХозрасчетныйОстаткиИОбороты.Счет,
	|	""Закрытие парных счетов""
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериодаНКР,
	|			Месяц,
	|			,
	|			Счет = &Счет
	|				ИЛИ Счет = &ПарныйСчет,
	|			,
	|			Субконто1 = &Субконто1) КАК ХозрасчетныйОстаткиИОбороты
	|ГДЕ
	|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстаток > 0";
	
	Если ТипЗнч(Субконто1) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 = &Субконто1", "Субконто1 = &Субконто1 И Субконто2 = &Договор");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СубконтоКт1 = &Субконто1", "СубконтоКт1 = &Субконто1 И СубконтоКт2 = &Договор");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СубконтоДт1 = &Субконто1", "СубконтоДт1 = &Субконто1 И СубконтоДт2 = &Договор");
	ИначеЕсли ТипЗнч(Субконто1) = Тип("СправочникСсылка.ФизическиеЛица") Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Субконто1 = &Субконто1", "Субконто1 = &Субконто1 И Валюта = &Валюта");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СубконтоКт1 = &Субконто1", "СубконтоКт1 = &Субконто1 И Валюта = &Валюта");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СубконтоДт1 = &Субконто1", "СубконтоДт1 = &Субконто1 И Валюта = &Валюта");
	КонецЕсли;		
	
	Запрос.УстановитьПараметр("Валюта", 		Валюта);
	Запрос.УстановитьПараметр("НачалоПериода", 	ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ДатаОкончания) - 1);
	Запрос.УстановитьПараметр("КонецПериодаНКР",КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("Счет", 			Счет);
	Запрос.УстановитьПараметр("ПарныйСчет", 	Счет.ПарныйСчет);
	Запрос.УстановитьПараметр("Субконто1", 		Субконто1);
	Запрос.УстановитьПараметр("Договор", 		Договор);
	Запрос.УстановитьПараметр("СчетаНКР", 		СчетаНКР);
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗначений;

КонецФункции // ПолучитьСводнуюТаблицуНКР()

&НаСервере
Процедура СформироватьТаблицуОКР()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозрасчетныйДвиженияССубконто.Период КАК Дата,
	|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
	|	ХозрасчетныйДвиженияССубконто.СчетДт КАК СчетДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютаДт КАК ВалютаДт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт1 КАК СубконтоДт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт2 КАК СубконтоДт2,
	|	ХозрасчетныйДвиженияССубконто.СчетКт КАК СчетКт,
	|	ХозрасчетныйДвиженияССубконто.ВалютаКт КАК ВалютаКт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт1 КАК СубконтоКт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт2 КАК СубконтоКт2,
	|	ХозрасчетныйДвиженияССубконто.Сумма КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Организация = &Организация
	|					И Субконто1 = &Субконто1
	|					И (СчетДт В (&СчетаОКР)
	|				ИЛИ СчетКт В (&СчетаОКР)),
	|			,
	|			) КАК ХозрасчетныйДвиженияССубконто
	|ГДЕ
	|	НЕ ХозрасчетныйДвиженияССубконто.Регистратор ССЫЛКА Документ.ЗакрытиеМесяца";
	
	Если ТипЗнч(Субконто1) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Субконто1", "&Субконто1 И Субконто2 = &Договор");
	ИначеЕсли ТипЗнч(Субконто1) = Тип("СправочникСсылка.ФизическиеЛица") Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Субконто1", "&Субконто1 И Валюта = &Валюта");
	КонецЕсли;		
	
	Запрос.УстановитьПараметр("Валюта", 		Валюта);
	Запрос.УстановитьПараметр("НачалоПериода", 	ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода", 	КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("Счет", 			Счет);
	Запрос.УстановитьПараметр("Субконто1", 		Субконто1);
	Запрос.УстановитьПараметр("Договор", 		Договор);
	Запрос.УстановитьПараметр("СчетаОКР", 		СчетаОКР);
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	ТаблицаОКР.Загрузить(ТаблицаЗначений);
	
КонецПроцедуры // СформироватьТаблицуОКР()

&НаКлиенте
Процедура ПроверитьРасшифровкуПоОКР()

	ТекущаяСтрока = Элементы.ТаблицаОКР.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если Не Элементы.ТаблицаОКРРасшифровка.Пометка Тогда
			СформироватьТаблицуРасшифровкаПоОКР(ТекущаяСтрока.Регистратор);
		КонецЕсли;
	КонецЕсли;
	УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры // ПоказатьРасшифровкуПоОКР()

&НаСервере
Процедура СформироватьТаблицуРасшифровкаПоОКР(Регистратор)
	
	РасшифровкаПоОКР.Очистить();	
	Регистр = РегистрыБухгалтерии.Хозрасчетный;
	
	ДвиженияБУ = Регистр.ВыбратьПоРегистратору(Регистратор);
	Пока ДвиженияБУ.Следующий() Цикл
		СтрокаТаблицы = РасшифровкаПоОКР.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДвиженияБУ);
		
		НомерСубконто = 0;
		Для каждого Субконто Из ДвиженияБУ.СубконтоДт Цикл
			СтрокаТаблицы["СубконтоДт" + (НомерСубконто + 1)] = Субконто.Значение;
		КонецЦикла;
		
		НомерСубконто = 0;
		Для каждого Субконто Из ДвиженияБУ.СубконтоКт Цикл
			СтрокаТаблицы["СубконтоКт" + (НомерСубконто + 1)] = Субконто.Значение;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // СформироватьТаблицуРасшифровкаПоОКР()

&НаКлиенте
Процедура ОбновитьДанные()
	
	ТекущаяСтрока = Элементы.СписокОСВ.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Субконто1 = ТекущаяСтрока.Субконто1;
		Счет = ТекущаяСтрока.Счет;
		Валюта = ТекущаяСтрока.Валюта;
		Если ТипЗнч(ТекущаяСтрока.Субконто2) = ТипЗнч(ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка")) Тогда 
			Договор	= ТекущаяСтрока.Субконто2; 
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.СтраницыОбработки.ТекущаяСтраница = Элементы.СтраницыОбработки.ПодчиненныеЭлементы.СтраницаНКР Тогда
		СформироватьТаблицуНКР();
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница = Элементы.СтраницыОбработки.ПодчиненныеЭлементы.СтраницаОКР Тогда
		СформироватьТаблицуОКР();
		ПроверитьРасшифровкуПоОКР();
	КонецЕсли;
	УстановитьПараметрыДинамическихСписков();

КонецПроцедуры // ОбновитьДанные()

&НаКлиенте
Процедура КурсыВалют(Команда)
	ТекущаяСтрока = Элементы.СписокОСВ.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Валюта = ТекущаяСтрока.Валюта;
		ЗначениеОтбора = Новый Структура("Валюта", Валюта);
		ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
		ОткрытьФорму("РегистрСведений.КурсыВалют.ФормаСписка", ПараметрыФормы);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыНКРВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СсылкаДокумента = Элементы.ДокументыНКР.ТекущиеДанные.Регистратор;
	НазваниеДокумента = ПолучитьНазваниеДокумента(СсылкаДокумента);
	ПараметрыФормы 	= Новый Структура("Ключ", СсылкаДокумента);
	ОткрытьФорму("Документ." + НазваниеДокумента + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

// Функция получения ссылок документов.
//
// Параметры:
//	Ссылка - ДокументСсылка - ссылка на выбранный документ.
//
// Возвращаемое значение:
//	Имя - Строка - название документа.
//
&НаСервере
Функция ПолучитьНазваниеДокумента(Ссылка)
	
	Возврат Ссылка.Метаданные().Имя

КонецФункции

&НаКлиенте
Процедура ТаблицаОКРВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СсылкаДокумента = Элементы.ТаблицаОКР.ТекущиеДанные.Регистратор;
	НазваниеДокумента = ПолучитьНазваниеДокумента(СсылкаДокумента);
	ПараметрыФормы 	= Новый Структура("Ключ", СсылкаДокумента);
	ОткрытьФорму("Документ." + НазваниеДокумента + ".ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти