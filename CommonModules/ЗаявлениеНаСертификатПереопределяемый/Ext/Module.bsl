﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов организации и при ее выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//
//    * Организация - СправочникСсылка.Организации - организация, которую нужно заполнить.
//                    Если организация уже заполнена, требуется перезаполнить ее свойства - например,
//                    при повтором вызове, когда пользователь выбрал другую организацию.
//                  - Неопределено, если ОпределяемыйТип.Организации не настроен.
//                    Пользователю недоступен выбор организации.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - (возвращаемое значение):
//                    Ложь   - начальное значение - указанная организация является юридическим лицом;
//                    Истина - указанная организация является индивидуальным предпринимателем.
//
//    * НаименованиеСокращенное  - Строка - (возвращаемое значение) краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеПолное       - Строка - (возвращаемое значение) краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                      - Строка - (возвращаемое значение) ИНН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП                      - Строка - (возвращаемое значение) КПП организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ОГРН                     - Строка - (возвращаемое значение) ОГРН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * РасчетныйСчет            - Строка - (возвращаемое значение) основной расчетный счет организации для договора.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * БИК                      - Строка - (возвращаемое значение) БИК банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КорреспондентскийСчет    - Строка - (возвращаемое значение) корреспондентский счет банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон                  - Строка - (возвращаемое значение) телефон организации в формате JSON, как его
//                                 возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//
//    * ЮридическийАдрес - Строка - (возвращаемое значение) юридический адрес организации в формате JSON, как его
//                         возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ФактическийАдрес - Строка - (возвращаемое значение) фактический адрес организации в формате JSON, как его
//                         возвращает функция КонтактнаяИнформацияОбъекта общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт

	// БПКР
	Если НЕ ЗначениеЗаполнено(Параметры.Организация) Тогда 
		Возврат;
	КонецЕсли;	
	
	ДанныеОбОрганизации = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Параметры.Организация, ТекущаяДатаСеанса());
	Параметры.НаименованиеСокращенное = ДанныеОбОрганизации.Наименование;
	Параметры.НаименованиеПолное      = ДанныеОбОрганизации.НаименованиеПолное;
	Параметры.ИНН                     = ДанныеОбОрганизации.ИНН;
	Параметры.РасчетныйСчет           = ДанныеОбОрганизации.НомерСчета;
	Параметры.БИК                     = ДанныеОбОрганизации.БИКБанка;
	Параметры.КорреспондентскийСчет   = ДанныеОбОрганизации.КоррСчетБанка;
	
	//Заполним контактную информацию
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	
	Объекты = Новый Массив();
	Объекты.Добавить(Параметры.Организация);
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, ТекущаяДатаСеанса());
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.ЮридическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.ФактическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.Телефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнении реквизитов владельца и при его выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация  - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                   - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипВладельца  - ОписаниеТипов - (возвращаемое значение) содержит ссылочные типы, из которых можно сделать выбор.
//                    - Неопределено  - (возвращаемое значение) выбор владельца не поддерживается.
//
//    * Сотрудник    - ТипВладельца - (возвращаемое значение) - это владелец сертификата, которого нужно заполнить.
//                     Если уже заполнен (выбран пользователем), его не следует изменять.
//                   - Неопределено - если ТипВладельца не определен, тогда реквизит не доступен пользователю.
//
//    * Директор     - ТипВладельца - (возвращаемое значение) - это директор, который может быть выбран,
//                     как владелец сертификата.
//                   - Неопределено - начальное значение - скрыть директора из списка выбора.
//
//    * ГлавныйБухгалтер - ТипВладельца - (возвращаемое значение) это главный бухгалтер, который может быть выбран
//                     как владелец сертификата.
//                   - Неопределено - начальное значение - скрыть главного бухгалтера из списка выбора.
//
//    * Пользователь - СправочникСсылка.Пользователи - (возвращаемое значение) пользователь - владелец сертификата.
//                     В общем случае может быть не заполнено. Рекомендуется заполнить, если есть возможность.
//                     Записывается в сертификат в поле Пользователь, может быть изменено в дальнейшем.
//
//    * Фамилия            - Строка - (возвращаемое значение) фамилия сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Имя                - Строка - (возвращаемое значение) имя сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Отчество           - Строка - (возвращаемое значение) отчество сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДатаРождения       - Дата   - (возвращаемое значение) дата рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Пол                - Строка - (возвращаемое значение) пол сотрудника "Мужской" или "Женский".
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * МестоРождения      - Строка - (возвращаемое значение) описание места рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Гражданство        - СправочникСсылка.СтраныМира - (возвращаемое значение) гражданство сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * СтраховойНомерПФР  - Строка - (возвращаемое значение) СНИЛС сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Должность          - Строка - (возвращаемое значение) должность сотрудника в организации.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Подразделение      - Строка - (возвращаемое значение) обособленное подразделение организации,
//                           в котором работает сотрудник.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументВид        - Строка - (возвращаемое значение) строки "21" или "91". 21 - паспорт гражданина РФ,
//                           91 - иной документ, предусмотренный законодательством РФ (по СПДУЛ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументНомер      - Строка - (возвращаемое значение) номер документа сотрудника (серия и
//                           номер для паспорта гражданина РФ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументКемВыдан   - Строка - (возвращаемое значение) кем выдан документ сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументКодПодразделения - Строка - (возвращаемое значение) - код подразделения, если вид документа 21.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументДатаВыдачи - Дата   - (возвращаемое значение) дата выдачи документа сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ЭлектроннаяПочта   - Строка - (возвращаемое значение) адрес электронной почты сотрудника в формате XML, как его
//                           возвращает функция КонтактнаяИнформацияВXML общего модуля УправлениеКонтактнойИнформацией.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БПКР
	ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Параметры.Организация, ТекущаяДатаСеанса());
	
	Параметры.Директор         = ОтветственныеЛица.Руководитель;
	Параметры.ГлавныйБухгалтер = ОтветственныеЛица.ГлавныйБухгалтер;
	
	Если ЗначениеЗаполнено(Параметры.Директор) Тогда
		ТекущийВладелец = Параметры.Директор;
		Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ГлавныйБухгалтер) Тогда
		ТекущийВладелец = Параметры.ГлавныйБухгалтер;
		Параметры.Должность = ОтветственныеЛица.ГлавныйБухгалтерДолжность;
	Иначе
		ТекущийВладелец = Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущийВладелец) Тогда
		Возврат; // Поля можно заполнить только, если сотрудник указан.
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо,
	|	ФизическиеЛица.ДатаРождения КАК ДатаРождения,
	|	ФизическиеЛица.Пол КАК Пол,
	|	ФизическиеЛица.ИНН КАК ИНН
	|ПОМЕСТИТЬ ВТВладелец
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ТекущийВладелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя КАК Имя,
	|	ФИОФизЛицСрезПоследних.Отчество КАК Отчество,
	|	ВТВладелец.ФизЛицо КАК ФизЛицо,
	|	ВТВладелец.ДатаРождения КАК ДатаРождения,
	|	ВТВладелец.Пол КАК Пол,
	|	ВТВладелец.ИНН КАК ИНН,
	|	ГражданствоФизическихЛицСрезПоследних.Страна КАК Гражданство,
	|	ДокументыФизическихЛицСрезПоследних.КодПодразделения КАК КодМВД,
	|	ДокументыФизическихЛицСрезПоследних.Серия КАК Серия,
	|	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи КАК ДатаВыдачи,
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан КАК КемВыдан
	|ИЗ
	|	ВТВладелец КАК ВТВладелец
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
	|				,
	|				ФизЛицо В
	|					(ВЫБРАТЬ
	|						ВТВладелец.ФизЛицо
	|					ИЗ
	|						ВТВладелец)) КАК ФИОФизЛицСрезПоследних
	|		ПО (ФИОФизЛицСрезПоследних.ФизЛицо = ВТВладелец.ФизЛицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизическихЛиц.СрезПоследних(
	|				,
	|				ФизЛицо В
	|					(ВЫБРАТЬ
	|						ВТВладелец.ФизЛицо
	|					ИЗ
	|						ВТВладелец)) КАК ГражданствоФизическихЛицСрезПоследних
	|		ПО (ГражданствоФизическихЛицСрезПоследних.ФизЛицо = ВТВладелец.ФизЛицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|				,
	|				ФизЛицо В
	|						(ВЫБРАТЬ
	|							ВТВладелец.ФизЛицо
	|						ИЗ
	|							ВТВладелец)
	|					И ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.Паспорт)) КАК ДокументыФизическихЛицСрезПоследних
	|		ПО (ДокументыФизическихЛицСрезПоследних.ФизЛицо = ВТВладелец.ФизЛицо)";
	
	Запрос.УстановитьПараметр("ТекущийВладелец", ТекущийВладелец);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Параметры.Фамилия  = Выборка.Фамилия;
		Параметры.Имя      = Выборка.Имя;
		Параметры.Отчество = Выборка.Отчество;
		
		Параметры.ДатаРождения  = Выборка.ДатаРождения;
		Параметры.Пол           = ?(Выборка.Пол = Перечисления.ПолФизическогоЛица.Женский, "Женский", "Мужской");
		Параметры.МестоРождения = "";
		Параметры.Гражданство   = Выборка.Гражданство;
		
		Параметры.ДокументВид        = Выборка.КодМВД;
		Параметры.ДокументНомер      = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"), Выборка.Серия, Выборка.Номер);
		Параметры.ДокументКемВыдан   = Выборка.КемВыдан;
		Параметры.ДокументДатаВыдачи = Выборка.ДатаВыдачи;
		
		Параметры.СтраховойНомерПФР  = Выборка.ИНН;
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов руководителя и при его выборе.
// Только для юридического лица. Для индивидуального предпринимателя не требуется.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация   - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                    - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипРуководителя - ОписаниеТипов - (возвращаемое значение) содержит ссылочные типы, из которых можно сделать выбор.
//                      - Неопределено  - (возвращаемое значение) выбор партнера не поддерживается.
//
//    * Руководитель  - ТипРуководителя - это значение, выбранное пользователем по которому нужно заполнить должность.
//                    - Неопределено - ТипРуководителя не определен.
//                    - ЛюбаяСсылка - (возвращаемое значение) - руководитель, который будет подписывать документы.
//
//    * Представление - Строка - (возвращаемое значение) представление руководителя.
//                    - Неопределено - получить представление от значения Руководитель.
//
//    * Должность     - Строка - (возвращаемое значение) - должность руководителя, который будет подписывать документы.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Основание     - Строка - (возвращаемое значение) - основание на котором действует
//                      должностное лицо (устав, доверенность, ...).
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БПКР
	Параметры.ТипРуководителя = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	
	ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Параметры.Организация, ТекущаяДатаСеанса());

	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Параметры.Руководитель = ОтветственныеЛица.Руководитель;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Возврат; // Поля можно заполнить только, если руководитель указан.
	КонецЕсли;
	
	Если Параметры.Руководитель = ОтветственныеЛица.Руководитель Тогда
		Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
		Параметры.Основание = НСтр("ru = 'Устав'");
	КонецЕсли;
	// Конец БПКР	
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов партнера и при его выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация   - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                    - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипПартнера   - ОписаниеТипов - содержит ссылочные типы из которых можно сделать выбор.
//                    - Неопределено - выбор партнера не поддерживается.
//
//    * Партнер       - ТипПартнера - это контрагент (обслуживающая организация), выбранный пользователем,
//                      по которому нужно заполнить реквизиты, описанные ниже.
//                    - Неопределено - ТипПартнера не определен.
//                    - ЛюбаяСсылка - (возвращаемое значение) - значение, сохраняемое в заявке для истории.
//
//    * Представление - Строка - (возвращаемое значение) представление партнера.
//                    - Неопределено - получить представление от значения Партнер.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - (возвращаемое значение):
//                      Ложь   - начальное значение - указанный партнер является юридическим лицом,
//                      Истина - указанный партнер является индивидуальным предпринимателем.
//
//    * ИНН           - Строка - (возвращаемое значение) ИНН партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП           - Строка - (возвращаемое значение) КПП партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
	// БПКР
	Параметры.ТипПартнера = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	Если Не ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Возврат; // Поля можно заполнить только, если партнер указан.
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Партнер, "ИНН, ЮрФизЛицо");
	
	Если Реквизиты.ЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Параметры.ЭтоИндивидуальныйПредприниматель = Истина;
	КонецЕсли;
	
	Параметры.ИНН = Реквизиты.ИНН;
	// Конец БПКР	
	
КонецПроцедуры

#КонецОбласти
