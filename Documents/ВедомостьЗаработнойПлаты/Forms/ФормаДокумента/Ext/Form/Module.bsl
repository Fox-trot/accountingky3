﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Подразделение = Объект.Подразделение;

	Если Не ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда 
		Объект.ПериодРегистрации = НачалоМесяца(ДатаДокумента);
	КонецЕсли;	
	
	СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);

	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

	// КопированиеСтрокТабличныхЧастей
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСервере(Элементы, "Зарплата");
	// Конец КопированиеСтрокТабличныхЧастей
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьСписокВыбораВидаДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборСотрудникаПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, "Зарплата");
	ИначеЕсли ИмяСобытия = "СозданиеДокументаОплатыИзВедомостиЗаработнойПлаты" Тогда
		СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
		Элементы.СписокДокументовВыплаты.Обновить();	
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Зарплата");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// РаботаСФормами
	РаботаСФормамиСервер.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Ложь);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Касса
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Истина);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Подразделение
//
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	// Значение реквизита не изменилось
	Если Объект.Подразделение = Подразделение Тогда 
		Возврат;
	КонецЕсли;	

	Если Объект.Зарплата.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧастьЗарплата", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		Подразделение = Объект.Подразделение;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВидВедомости.
//
&НаКлиенте
Процедура ВидВедомостиПриИзменении(Элемент)
	
	Если Объект.ВидВедомости = 3
		ИЛИ Объект.ВидВедомости = 4 Тогда
		Объект.ВидДокументаВыплаты = 4;	
		
	Иначе
		Объект.ВидДокументаВыплаты = Неопределено;
	КонецЕсли;	
	
	СформироватьСписокВыбораВидаДокумента();
	УстановитьВидимостьДоступностьЭлементов();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиЗарплата

&НаКлиенте
Процедура ЗарплатаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования 
		Или Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	СтрокаТабличнойЧасти.РучнаяКорректировка = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ПересчитатьТаблицуВыплат();
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПослеУдаления(Элемент)
	ПересчитатьТаблицуВыплат();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗарплатаКартСчет.
//
&НаКлиенте
Процедура ЗарплатаКартСчетПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.КартСчет) Тогда
		УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(СтрокаТабличнойЧасти.БанкКартСчета, СтрокаТабличнойЧасти.КартСчет);
	Иначе
		СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗарплатаБанковскийСчет.
//
&НаКлиенте
Процедура ЗарплатаБанковскийСчетПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.БанковскийСчет) Тогда
		УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(СтрокаТабличнойЧасти.БанкБанковскогоСчета, СтрокаТабличнойЧасти.БанковскийСчет);
	Иначе
		СтрокаТабличнойЧасти.СуммаПоБанковскомуСчету = 0;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗарплатаСуммаПоБанковскомуСчету.
//
&НаКлиенте
Процедура ЗарплатаСуммаПоБанковскомуСчетуПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.БанковскийСчет) Тогда
		СтрокаТабличнойЧасти.СуммаПоБанковскомуСчету = 0;
		ТекстСообщения = НСтр("ru = 'Не выбран банковский счет сотруднкика.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗарплатаСуммаПоКартСчету.
//
&НаКлиенте
Процедура ЗарплатаСуммаПоКартСчетуПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.КартСчет) Тогда
		СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
		ТекстСообщения = НСтр("ru = 'Не выбран карт счет сотруднкика.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаФизЛицоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ СтрокаТабличнойЧасти = Неопределено Тогда
		Если Объект.ВидВедомости = 3 Тогда
			СтрокаТабличнойЧасти.БанковскийСчет = БанковскийСчетСотрудника(СтрокаТабличнойЧасти.ФизЛицо); 	
		ИначеЕсли Объект.ВидВедомости = 4 Тогда
		    СтрокаТабличнойЧасти.КартСчет = КартСчетСотрудника(СтрокаТабличнойЧасти.ФизЛицо);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументовВыплаты

&НаКлиенте
Процедура СписокДокументовВыплатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("Заполнить");
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидЗаполненияТабличнойЧасти", Команда.Имя);	
	Если Объект.Зарплата.Количество() > 0 Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗаМесяц(Команда)

	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("Заполнить");
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидЗаполненияТабличнойЧасти", Команда.Имя);	
	Если Объект.Зарплата.Количество() > 0 Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	СотрудникиКлиент.ОткрытьПодбор(ЭтаФорма, "Зарплата");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументыВыплаты(Команда)
	
	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("СформироватьДокументыВыплаты");	
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;
	
	// Подотчет, авансовый отчет.
	Если Объект.ВидДокументаВыплаты = 5 Тогда
		ОткрытьФормуДокумента();
	Иначе	
		СформироватьДокументыВыплатыНаСервере();
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
	
	// Обновление динамических списков, в том числе и на этой форме.
	Оповестить("СозданиеДокументаОплатыИзВедомостиЗаработнойПлаты");
	
	ТекстОповещения = НСтр("ru = 'Создание'");
	ТекстПояснения = НСтр("ru = 'Документы выплаты созданы'");
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Зарплата.Очистить();
		Объект.ТаблицаВыплат.Очистить();
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросОчиститьТабличнуюЧастьЗарплата(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Подразделение = Объект.Подразделение;
		Объект.Зарплата.Очистить();
		Объект.ТаблицаВыплат.Очистить();
	Иначе
		// Отмена изменения - возврат прежних значений
		Объект.Подразделение = Подразделение;     
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	Банк - Справочники.Банки, ссылка на банк.
//
//	Счет - Справочники.КартСчетаСотрудников, Справочники.БанковскиеСчета, ссылка на карт счет или банковский счет.
//
Процедура УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(Банк, Счет)
	Банк = Счет.Банк;		
КонецПроцедуры

&НаСервере
// Процедура пересчитывает ТЧ "ТаблицаВыплат" при изменениях в ТЧ "Зарплата".
//
Процедура ПересчитатьТаблицуВыплат()

	Объект.ТаблицаВыплат.Очистить();
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДополнительныеСвойства.Вставить("ПериодРегистрации", Объект.ПериодРегистрации);
	
	ТаблицаЗарплата = Объект.Зарплата.Выгрузить();
	
	// Все, Касса.
	Если Объект.ВидВедомости = 1
		ИЛИ Объект.ВидВедомости = 2 Тогда
		Документ.ЗаполнитьТаблицуВыплатПоКассе(ТаблицаЗарплата.Итог("СуммаПоКассе"));
	// Банк.
	ИначеЕсли Объект.ВидВедомости = 3 Тогда
		Документ.ЗаполнитьТаблицуВыплатПоБанковскимСчетам(ТаблицаЗарплата.Итог("СуммаПоБанковскомуСчету"));
	// ЗП проект.	
	ИначеЕсли Объект.ВидВедомости = 4 Тогда
		Документ.ЗаполнитьТаблицуВыплатПоЗППроектам(ТаблицаЗарплата); 
	КонецЕсли;	

	ЗначениеВРеквизитФормы(Документ, "Объект");
	
КонецПроцедуры

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	ПересчитатьОстатокПоКассе - Булево, признак для определения по кассе или банковскому счету 
//										необходимо пересчитать сумму остаток.
//
Процедура ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(ПересчитатьОстатокПоКассе)
	
	Документ = РеквизитФормыВЗначение("Объект");
	СуммаОстатка = Документ.ПолучитьОстатокПоКассеИлиБанковскомуСчету(ПересчитатьОстатокПоКассе);	
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТаблицаВыплат Цикл
		Если ПересчитатьОстатокПоКассе Тогда
			Если СтрокаТабличнойЧасти.Наименование = "Касса" Тогда
				СтрокаТабличнойЧасти.СуммаОстаток = СуммаОстатка;
				Прервать;
			КонецЕсли;
		Иначе
			Если НЕ СтрокаТабличнойЧасти.Наименование = "Касса" Тогда
				СтрокаТабличнойЧасти.СуммаОстаток = СуммаОстатка;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.Касса.Видимость 					  	   	= Ложь;
	Элементы.БанковскийСчет.Видимость			  	   	= Ложь;
	Элементы.БанковскийСчетЗППроекта.Видимость 			= Ложь;
	Элементы.ЗарплатаБанковскийСчет.Видимость		   	= Ложь;
	Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость 	= Ложь;
	Элементы.ЗарплатаКартСчет.Видимость		  		   	= Ложь;
	Элементы.ЗарплатаСуммаПоКартСчету.Видимость		   	= Ложь;
	Элементы.ЗарплатаСуммаПоКассе.Видимость		  	   	= Ложь;
	Элементы.ЗарплатаИтогПоБанковскомуСчету.Видимость	= Ложь;
	Элементы.ЗарплатаИтогПоКартСчету.Видимость			= Ложь;
	Элементы.ЗарплатаИтогПоКассе.Видимость				= Ложь;
	
	// Банк.
	Если Объект.ВидВедомости = 3 Тогда
		Элементы.БанковскийСчет.Видимость 				   	= Истина;
		Элементы.ЗарплатаБанковскийСчет.Видимость		   	= Истина;
		Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость 	= Истина;
		Элементы.ЗарплатаИтогПоБанковскомуСчету.Видимость	= Истина;
		Элементы.ВидДокументаВыплаты.Видимость 				= Ложь;
	КонецЕсли;
	
	// Все, Касса.
	Если Объект.ВидВедомости = 1 
		Или Объект.ВидВедомости = 2 Тогда
		Элементы.Касса.Видимость 		  		= Истина;
		Элементы.ЗарплатаСуммаПоКассе.Видимость	= Истина;
		Элементы.ЗарплатаИтогПоКассе.Видимость	= Истина;
		Элементы.ВидДокументаВыплаты.Видимость = Истина;
	КонецЕсли;
	
	// ЗП проект
	Если Объект.ВидВедомости = 4 Тогда
		Элементы.БанковскийСчет.Видимость 			= Истина;
		Элементы.БанковскийСчетЗППроекта.Видимость 	= Истина;
		Элементы.ЗарплатаКартСчет.Видимость		  	= Истина;
		Элементы.ЗарплатаСуммаПоКартСчету.Видимость	= Истина;
		Элементы.ЗарплатаИтогПоКартСчету.Видимость	= Истина;
		Элементы.ВидДокументаВыплаты.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ЗарплатаПодразделение.Видимость = Объект.Подразделение.Пустая();
	
	КоличествоСозданныхДокументов = КоличествоДокументов();
	
	Если КоличествоСозданныхДокументов > 0 Тогда
		Элементы.СформироватьДокументыВыплаты.Видимость = Ложь;
	Иначе
		Элементы.СформироватьДокументыВыплаты.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СформироватьСписокВыбораВидаДокумента()

	Элементы.ВидДокументаВыплаты.СписокВыбора.Очистить();
	
	// Все, Касса.
	Если Объект.ВидВедомости = 1
		Или Объект.ВидВедомости = 2 Тогда
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(1, "Общий");
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(2, "Индивидуальный");
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(5, "АвансовыйОтчет");
	// Банк, ЗП проект.	
	ИначеЕсли Объект.ВидВедомости = 3
		ИЛИ Объект.ВидВедомости = 4 Тогда
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(4, "ППИ");
	КонецЕсли;
КонецПроцедуры

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Функция возвращает результат возможности записи/отмены проведения документа перед расчетом
//
// Параметры:
//  Действие - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда 
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Модифицированность = Ложь;
	
	Возврат НЕ Объект.Проведен И ЗначениеЗаполнено(Объект.Ссылка);
КонецФункции // ЗаписатьДокументОтменивПроведение()

&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	ДополнительныеПараметры - Структура, необходимые данные для отборов при заполнении.
//
Процедура ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДополнительныеСвойства.Вставить("ВидЗаполненияТабличнойЧасти", ДополнительныеПараметры.ВидЗаполненияТабличнойЧасти);
	Документ.ДополнительныеСвойства.Вставить("ПериодРегистрации", 			Объект.ПериодРегистрации);
	Документ.ЗаполнитьТабличнуюЧасть();                           	
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность = Истина
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

// Процедура получает результат подбора из временного хранилища
//
&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивФизЛиц = Новый Массив;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект[ИмяТабличнойЧасти].НайтиСтроки(Новый Структура("ФизЛицо", СтрокаЗагрузки.ФизЛицо));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		МассивФизЛиц.Добавить(СтрокаТабличнойЧасти.ФизЛицо);
	КонецЦикла;
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Функция проверяет наличие значений определенных реквизитов по условиям.
// 
// Возвращаемое значение:
//		Отказ - булево, для отмены исполнения команд, если не заполнены определенные реквизиты.
//
&НаСервере
Функция ПроверкаЗаполненияПередИсполнениемКоманды(НаименованиеКоманды)

	Отказ = Ложь;
	
	Если НаименованиеКоманды = "СформироватьДокументыВыплаты" Тогда		
		Если Объект.Зарплата.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Табличная часть ""Зарплата"" пустая. Создание документов отменено.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)
		КонецЕсли;
		
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("СуммаПоБанковскомуСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКартСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКассе", 0);
		
		Если Объект.Зарплата.НайтиСтроки(СтруктураОтбор).Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru = 'В табличной части ""Зарплата"" есть строка(и) с незаполненными суммами. Создание документов отменено.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)	
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидДокументаВыплаты) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Вид документа выплаты'"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ВидДокументаВыплаты",, Отказ);
		КонецЕсли;	
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен период. Заполнение документа отменено.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "МесяцСтрокой",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПорядокОкругления) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле Порядок округления. Заполнение документа отменено.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ПорядокОкругления",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидВедомости) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Вид ведомости'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.ВидВедомости",, Отказ);
	КонецЕсли;
	
	// Общий, Индивидуальный, Подотчет.
	Если (Объект.ВидДокументаВыплаты = 1
		Или Объект.ВидДокументаВыплаты = 2)
		И НЕ ЗначениеЗаполнено(Объект.Касса) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Касса'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Касса",, Отказ);
	КонецЕсли;
	
	// Банк, ЗП проект.
	Если (Объект.ВидВедомости = 3
		Или Объект.ВидВедомости = 4)
		И НЕ ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Банковский счет'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.БанковскийСчет",, Отказ);
	КонецЕсли;
	
	Возврат Отказ;
КонецФункции

// Функция считывает данные динамического списка.
// 
// Возвращаемое значение:
//  Количество - Число
//
&НаСервере
Функция КоличествоДокументов()
	
	Схема = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат Результат.Количество();
КонецФункции

// Процедура подготавливает данные для создания документов выплаты.
//
&НаСервере
Процедура СформироватьДокументыВыплатыНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПодготовитьДанныеДляДокументовВыплаты();                           	
	ЗначениеВРеквизитФормы(Документ, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДокумента()
	
	СтруктураПараметры = Новый Структура();
	СтруктураПараметры.Вставить("ВедомостьЗаработнойПлаты",		Объект.Ссылка);
	СтруктураПараметры.Вставить("Организация", 					Объект.Организация);
	СтруктураПараметры.Вставить("Касса", 						Объект.Касса);
	СтруктураПараметры.Вставить("СуммаПлатежа", 					Объект.СуммаДокумента);
	СтруктураПараметры.Вставить("ТаблицаЗарплата", 				Объект.Зарплата);
	СтруктураПараметры.Вставить("СтатьяДвиженияДенежныхСредств", Объект.СтатьяДвиженияДенежныхСредств);
	                            
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииПодчиненнойФормы", ЭтаФорма);
	
	ОткрытьФорму("Документ.АвансовыйОтчет.Форма.ФормаДокумента", 
		СтруктураПараметры, ЭтаФорма, Истина, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииПодчиненнойФормы(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Элементы.СписокДокументовВыплаты.Обновить();	

КонецПроцедуры

&НаСервереБезКонтекста
Функция БанковскийСчетСотрудника(ФизЛицо)
	Если НЕ ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	БанковскийСчет = ФизЛицо.ОсновнойБанковскийСчет;
	
	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	БанковскиеСчета.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.БанковскиеСчета КАК БанковскиеСчета
			|ГДЕ
			|	БанковскиеСчета.Владелец = &ФизЛицо";
		
		Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			БанковскийСчет = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат БанковскийСчет;

КонецФункции // БанковскийСчетСотрудника()

&НаСервереБезКонтекста
Функция КартСчетСотрудника(ФизЛицо)
	Если НЕ ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КартСчетаСотрудников.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КартСчетаСотрудников КАК КартСчетаСотрудников
		|ГДЕ
		|	КартСчетаСотрудников.Владелец = &ФизЛицо
		|	И НЕ КартСчетаСотрудников.ВАрхиве";
	
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КартСчет = Неопределено;
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		КартСчет = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат КартСчет;

КонецФункции // БанковскийСчетСотрудника()

#КонецОбласти

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПериодРегистрации.
//
&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
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

#Область КопированиеСтрокТабличныхЧастей

&НаКлиенте
Процедура ЗарплатаКопироватьСтроки(Команда)
	
	КопироватьСтроки("Зарплата");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаВставитьСтроки(Команда)
	
	ВставитьСтроки("Зарплата");
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСтроки(ИмяТЧ)
	
	Если КопированиеТабличнойЧастиКлиент.МожноКопироватьСтроки(Объект[ИмяТЧ], Элементы[ИмяТЧ].ТекущиеДанные) Тогда
		КоличествоСкопированных = 0;
		КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных);
		КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОКопированииСтрок(КоличествоСкопированных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(ИмяТЧ)
	
	КоличествоСкопированных = 0;
	КоличествоВставленных = 0;
	ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных);
	КопированиеТабличнойЧастиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура КопироватьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных)
	
	КопированиеТабличнойЧастиСервер.Копировать(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки, КоличествоСкопированных);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьСтрокиНаСервере(ИмяТЧ, КоличествоСкопированных, КоличествоВставленных)
	
	КопированиеТабличнойЧастиСервер.Вставить(Объект, ИмяТЧ, Элементы, КоличествоСкопированных, КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

