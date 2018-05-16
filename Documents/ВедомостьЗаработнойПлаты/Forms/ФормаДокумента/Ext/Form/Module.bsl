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
	КопированиеТабличнойЧастиСервер.ПриСозданииНаСевере(Элементы, "Зарплата");
	// Конец КопированиеСтрокТабличныхЧастей

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
	ИначеЕсли ИмяСобытия = "ОповеститьОСозданииНаОснованииВедомостьЗаработнойПлаты" Тогда
		СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
		Элементы.СписокДокументовВыплаты.Обновить();	
	КонецЕсли;
	
	// КопированиеСтрокТабличныхЧастей
	Если ИмяСобытия = "БуферОбменаТабличнаяЧастьКопированиеСтрок" Тогда
		КопированиеТабличнойЧастиКлиент.ОбработкаОповещения(Элементы, "Зарплата");
	КонецЕсли;
	// Конец КопированиеСтрокТабличныхЧастей
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

//Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Ложь);
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода Касса
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Истина);
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода Подразделение
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
		УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(СтрокаТабличнойЧасти.БанкБанковскийСчет, СтрокаТабличнойЧасти.БанковскийСчет);
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
		ТекстСообщения = НСтр("ru = 'Не выбран банковский счет сотруднкика!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗарплатаСуммаПоКартСчету.
//
&НаКлиенте
Процедура ЗарплатаСуммаПоКартСчетуПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.КартСчет) Тогда
		СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
		ТекстСообщения = НСтр("ru = 'Не выбран карт счет сотруднкика!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументовВыплаты

&НаКлиенте
Процедура СписокДокументовВыплатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
	ДокументМенеджер = ДанныеДинамическогоСписка("СписокДокументовВыплатыВыбор", ВыбраннаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ОткрытьФорму(ДокументМенеджер + ".ФормаОбъекта", ПараметрыФормы, Элемент);
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
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
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
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
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
	Если Объект.ВидДокументаВыплаты = 3 
		ИЛИ Объект.ВидДокументаВыплаты = 5 Тогда
		ОткрытьФормуДокумента();
	Иначе	
		СформироватьДокументыВыплатыНаСервере();
	КонецЕсли;
	УстановитьВидимостьДоступностьЭлементов();
	
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
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
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
//										необходимо перечститать сумму остаток.
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
	Элементы.ЗарплатаБанковскийСчет.Видимость		   	= Ложь;
	Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость 	= Ложь;
	Элементы.ЗарплатаКартСчет.Видимость		  		   	= Ложь;
	Элементы.ЗарплатаСуммаПоКартСчету.Видимость		   	= Ложь;
	Элементы.ЗарплатаСуммаПоКассе.Видимость		  	   	= Ложь;
	Элементы.ЗарплатаИтогПоБанковкомуСчету.Видимость	= Ложь;
	Элементы.ЗарплатаИтогПоКартСчету.Видимость			= Ложь;
	Элементы.ЗарплатаИтогПоКассе.Видимость				= Ложь;
	
	// Банк.
	Если Объект.ВидВедомости = 3 Тогда
		Элементы.БанковскийСчет.Видимость 				   	= Истина;
		Элементы.ЗарплатаБанковскийСчет.Видимость		   	= Истина;
		Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость 	= Истина;
		Элементы.ЗарплатаИтогПоБанковкомуСчету.Видимость	= Истина;
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
		Элементы.ЗарплатаКартСчет.Видимость		  	= Истина;
		Элементы.ЗарплатаСуммаПоКартСчету.Видимость	= Истина;
		Элементы.ЗарплатаИтогПоКартСчету.Видимость	= Истина;
		Элементы.ВидДокументаВыплаты.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ЗарплатаПодразделение.Видимость = Объект.Подразделение.Пустая();
	
	КоличествоСозданныхДокументов = ДанныеДинамическогоСписка("УстановитьВидимостьДоступностьЭлементов");
	
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
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(3, "Подотчет");
		Элементы.ВидДокументаВыплаты.СписокВыбора.Добавить(5, "АвансовыйОтчет");
	// Банк, За прект.	
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

// Функция возвращает ответ пользователя о возможности записи/отмене проведения документа перед рассчетом
//
// Параметры:
//  Действие  - Строка - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли Модифицированность 
		Или ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);
		СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
	КонецЕсли;	
	
	Возврат Истина;
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
			ТекстСообщения = НСтр("ru = 'Табличная часть ""Зарплата"" пустая! Создание документов отменено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)
		КонецЕсли;
		
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("СуммаПоБанковскомуСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКартСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКассе", 0);
		
		Если Объект.Зарплата.НайтиСтроки(СтруктураОтбор).Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru = 'В табличной части ""Зарплата"" есть строка(и) с незаполненными суммами! Создание документов отменено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)	
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидДокументаВыплаты) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Вид документа выплаты'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ВидДокументаВыплаты",, Отказ);
		КонецЕсли;	
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен период! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "МесяцСтрокой",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПорядокОкругления) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле Порядок округления! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ПорядокОкругления",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидВедомости) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Вид ведомости'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ВидВедомости",, Отказ);
	КонецЕсли;
	
	// Общий, Индивидуальный, Подотчет.
	Если (Объект.ВидДокументаВыплаты = 1
		Или Объект.ВидДокументаВыплаты = 2
		Или Объект.ВидДокументаВыплаты = 3) 
		И НЕ ЗначениеЗаполнено(Объект.Касса) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Касса'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Касса",, Отказ);
	КонецЕсли;
	
	// Банк, ЗП проект.
	Если (Объект.ВидВедомости = 3
		Или Объект.ВидВедомости = 4)
		И НЕ ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Банковский счет'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.БанковскийСчет",, Отказ);
	КонецЕсли;
	
	Возврат Отказ;
КонецФункции

// Функция считывает данные динамического списка.
//
// Параметры:
//  ПроцедураОбращения - Строка - название процедуры обращения к функции.
//  ВыбраннаяСтрока - Число - номер выбираемой строки в динамичеком списке.
//
// Возвращаемое значение:
//		Если ВыбраннаяСтрока = Неопределено Тогда
//			Результат.Количество() - Число, количество строк в динамическом списке.
//		Иначе
//			ДокументМенеджер - Строка, название документа, для создания.
//
&НаСервере
Функция ДанныеДинамическогоСписка(ПроцедураОбращения, ВыбраннаяСтрока = Неопределено)
	
	Схема = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ПроцедураОбращения = "УстановитьВидимостьДоступностьЭлементов" Тогда
		Возврат Результат.Количество();
	ИначеЕсли ПроцедураОбращения = "СписокДокументовВыплатыВыбор" Тогда		
		ВыбраннаяСтрока = ВыбраннаяСтрока - 1;	
		Если ТипЗнч(Результат[ВыбраннаяСтрока].Ссылка) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") Тогда
			ДокументМенеджер = "Документ.ПлатежноеПоручениеИсходящее";
		ИначеЕсли ТипЗнч(Результат[ВыбраннаяСтрока].Ссылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			ДокументМенеджер = "Документ.РасходныйКассовыйОрдер";
		Иначе
			ДокументМенеджер = "Документ.АвансовыйОтчет";
		КонецЕсли;
		
		Возврат ДокументМенеджер;
	КонецЕсли;		
КонецФункции

// Процедура подготавливает данные для создания документов выплаты.
//
&НаСервере
Процедура СформироватьДокументыВыплатыНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПодготовитьДанныеДляДокументовВыплаты();                           	
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Элементы.СписокДокументовВыплаты.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДокумента()
	
	СтруктраПараметры = Новый Структура();
	СтруктраПараметры.Вставить("ВедомостьЗаработнойПлаты", 					Объект.Ссылка);
	СтруктраПараметры.Вставить("Организация", 					Объект.Организация);
	СтруктраПараметры.Вставить("Касса", 						Объект.Касса);
	СтруктраПараметры.Вставить("СуммаПлатежа", 					Объект.СуммаДокумента);
	СтруктраПараметры.Вставить("ТаблицаЗарплата", 				Объект.Зарплата);
	СтруктраПараметры.Вставить("СтатьяДвиженияДенежныхСредств", Объект.СтатьяДвиженияДенежныхСредств);
	                            
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииПодчиненнойФормы", ЭтаФорма);
	
	// Подотчет.
	Если Объект.ВидДокументаВыплаты = 3 Тогда
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.Форма.ФормаДокумента", 
			СтруктраПараметры, ЭтаФорма, Истина, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Документ.АвансовыйОтчет.Форма.ФормаДокумента", 
			СтруктраПараметры, ЭтаФорма, Истина, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;			
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииПодчиненнойФормы(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Элементы.СписокДокументовВыплаты.Обновить();	

КонецПроцедуры

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
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

