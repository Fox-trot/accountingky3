﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();

	// Проверка наличия текущего задания по обновлению ТН ВЭД
	ВыполняетсяОбновлениеТНВЭД = ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено).Свойство("Активно");
		
	Если Не ВыполняетсяОбновлениеТНВЭД Тогда
		АктуализироватьСостояниеОбновленияТНВЭД();
	КонецЕсли;

	ЗаполнитьСписокВыбораТочностьЦены();	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейс = Истина;
	
	ЭтотОбъект.Прочитать();
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры // ПриЗакрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды НастройкаУчетаПоОрганизациям
//
&НаКлиенте
Процедура НастройкаУчетаПоОрганизациям(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкаУчетаПоОрганизации");
КонецПроцедуры // НастройкаУчетаПоОрганизациям()

// Процедура - обработчик команды НастройкаДляРозничныхПродаж
//
&НаКлиенте
Процедура НастройкаДляРозничныхПродаж(Команда)
	ОткрытьФорму("РегистрСведений.НастройкиДляРозничныхПродаж.ФормаСписка");
КонецПроцедуры

// Процедура - обработчик команды НастройкаСчетаУчетаСОсобымПорядкомПереоценки
//
&НаКлиенте
Процедура НастройкаСчетовУчетаСОсобымПорядкомПереоценки(Команда)
	ОткрытьФорму("РегистрСведений.СчетаУчетаСОсобымПорядкомПереоценки.ФормаСписка");
КонецПроцедуры // НастройкаСчетаУчетаСОсобымПорядкомПереоценки()

// Процедура - обработчик команды СправочникОрганизации.
//
&НаКлиенте
Процедура СправочникОрганизации(Команда)
	Если НаборКонстант.ФункциональнаяОпцияУчетПоНесколькимОрганизациям Тогда 
		ОткрытьФорму("Справочник.Организации.ФормаСписка");
	Иначе 	
		Парам = Новый Структура("Ключ", БухгалтерскийУчетВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
		ОткрытьФорму("Справочник.Организации.ФормаОбъекта", Парам);
	КонецЕсли;	
КонецПроцедуры // СправочникОрганизации()

// Процедура - обработчик команды СправочникПодразделения.
//
&НаКлиенте
Процедура СправочникПодразделения(Команда)
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаСписка");
КонецПроцедуры // СправочникПодразделения()

&НаКлиенте
Процедура УчетнаяПолитика(Команда)
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаОрганизаций.ФормаСписка");
КонецПроцедуры

// Процедура - обработчик команды СправочникВалюты.
//
&НаКлиенте
Процедура СправочникВалюты(Команда)
	ОткрытьФорму("Справочник.Валюты.ФормаСписка");
КонецПроцедуры // СправочникВалюты()

&НаКлиенте
Процедура УчетнаяПолитикаПоПерсоналу(Команда)
	ОткрытьФорму("РегистрСведений.УчетнаяПолитикаПоПерсоналу.ФормаСписка");
КонецПроцедуры

// Процедура - обработчик команды НастройкаУчетаПоСкладам
//
&НаКлиенте
Процедура НастройкаУчетаПоСкладам(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкаУчетаПоСкладам");
КонецПроцедуры 

// Процедура - обработчик команды НастройкаЗаполненияЦен
//
&НаКлиенте
Процедура НастройкаЗаполненияЦен(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ФормаНастройкиЦен");
КонецПроцедуры 

// Процедура - обработчик команды НастройкаУчетаПоСтатьямДДС
//
&НаКлиенте
Процедура НастройкаУчетаПоСтатьямДДС(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкаУчетаПоСтатьямДДС");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСистемы(Команда)
	ОбновитьИнтерфейс();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ЭСФ

&НаКлиенте
Процедура ФункциональнаяОпцияЭСФПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры

#КонецОбласти

#Область ДенежныеСредства

// Процедура - обработчик события ПриИзменении поля ввода СтатьяДДСКурсоваяРазница.
//
&НаКлиенте
Процедура СтатьяДДСКурсоваяРазницаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСДляОплатыОтПокупателяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСДляОплатыПоставщикуПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСДляПрочихПоступленийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСДляПрочихВыбытийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСДляВнутреннихОборотовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПоПлатежнымКартамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияПрефиксКассыИБанковскогоСчета.
//
&НаКлиенте
Процедура ФункциональнаяОпцияПрефиксКассыИБанковскогоСчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
	// Очистка префиксов
	Если Не НаборКонстант.ФункциональнаяОпцияПрефиксКассыИБанковскогоСчета Тогда
		ВыполнитьПроверкуПрефиксов();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ВалютныйУчет

// Процедура - обработчик события ПриИзменении поля ВалютаРегламентированногоУчета.
//
&НаКлиенте
Процедура ВалютаРегламентированногоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры // ВалютаРегламентированногоУчетаПриИзменении()

#КонецОбласти

#Область ОсновныеСредства

// Процедура - обработчик события ПриИзменении поля ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетДвиженияОСПоПодразделениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетДвиженияОСПоМОЛПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ФункциональнаяОпцияВестиУчетОСПоКомплектам.
//
&НаКлиенте
Процедура ФункциональнаяОпцияВестиУчетОСПоКомплектамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ВычетНАПриМодернизации.
//
&НаКлиенте
Процедура ВычетНАПриМодернизацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ЗарплатаИПерсонал

// Процедура - обработчик события ПриИзменении поля УчетЗаработнойПлатыВВалюте.
//
&НаКлиенте
Процедура ФункциональнаяОпцияУчетЗаработнойПлатыВВалютеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля КонтролироватьПоШтатномуРасписанию.
//
&НаКлиенте
Процедура ФункциональнаяОпцияВестиШтатноеРасписаниеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКонтрольЗапретаСтавкиПоШтатномуРасписаниюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ НаборКонстант.ВвестиКонтрольЗапретаСтавкиПоШтатномуРасписанию Тогда 
		НаборКонстант.ВвестиКонтрольЗапретаРазмераПоШтатномуРасписанию = Ложь;	
	КонецЕсли;	
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКонтрольЗапретаРазмераПоШтатномуРасписаниюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КурсыВалютЗаработнаяПлата(Команда)
	ОткрытьФорму("РегистрСведений.КурсыВалютЗаработнаяПлата.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область Производство

// Процедура - обработчик команды НастройкаУчетаПоСкладам
//
&НаКлиенте
Процедура НастройкаУчетаПроизводства(Команда)
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкаУчетаПроизводства");
КонецПроцедуры 

&НаКлиенте
Процедура МетодыРаспределенияКосвенныхРасходов(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", 
		БухгалтерскийУчетВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация")));
	ОткрытьФорму("РегистрСведений.МетодыРаспределенияКосвенныхРасходовОрганизаций.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ДоходыИРасходы

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.
//
&НаКлиенте
Процедура ФункциональнаяОпцияДопРасходыНаНесколькоПоступленийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ПокупкаИПродажа

// Процедура - обработчик события ПриИзменении поля ввода СрокОплатыПокупателей.
//
&НаКлиенте
Процедура СрокОплатыПокупателейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Оповестить("ИзменениеСрокаОплатыПокупателями");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода СрокОплатыПоставщикам.
//
&НаКлиенте
Процедура СрокОплатыПоставщикамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Оповестить("ИзменениеСрокаОплатыПоставщикам");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КонтролироватьОстаткиПриПроведении.
//
&НаКлиенте
Процедура ПечататьСчетаФактурыСГоловнымКонтрагентомПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);	
	Если НЕ НаборКонстант.ФункциональнаяОпцияВестиРозничныеПродажи Тогда 
		НаборКонстант.ИспользуютсяПодарочныеСертификаты = Ложь;
	КонецЕсли;	
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ИспользуютсяПодарочныеСертификатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СистемаНалогооблаженияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура - обработчик события ПриИзменении поля ввода МакетОформленияОтчетов.
//
&НаКлиенте
Процедура МакетОформленияОтчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КонтролироватьОстаткиПриПроведении.
//
&НаКлиенте
Процедура КонтролироватьОстаткиПриПроведенииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьДублированиеНоменклатурыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФункциональнаяОпцияУказыватьТочностьЦеныПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТочностьЦеныПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияИспользоватьПодключаемоеОборудование.
//
&НаКлиенте
Процедура ФункциональнаяОпцияИспользоватьПодключаемоеОборудованиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФункциональнаяОпцияОтчетыВРазныеГНС.
//
&НаКлиенте
Процедура ФункциональнаяОпцияОтчетыВРазныеГНСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФункциональнаяОпцияКомплектацияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтдельнаяПроводкаПоСкидкеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ТНВЭД

&НаКлиенте
Процедура ОбновитьТНВЭД(Команда)
	
	Отказ = Ложь;
	
	ЗапуститьОбновлениеТНВЭД(РазделениеВключено, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДлительнаяОперацияОбновлениеТНВЭД.Видимость = Истина;
	Элементы.СостояниеОбновленияТНВЭД.Заголовок = НСтр("ru = 'Выполняется обновление'");
	Элементы.ОбновитьТНВЭД.Доступность = Ложь;
	
	ПодключитьОбработчикОжидания("ПроверитьОбновлениеТНВЭД", 2);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапуститьОбновлениеТНВЭД(РазделениеВключено, Отказ)
	
	ЭлементыТНВЭД = Новый Массив;
	ОблачныеКлассификаторыПереопределяемый.ОпределитьЗагруженныеЭлементыТНВЭД(ЭлементыТНВЭД);
	
	Если Не ЭлементыТНВЭД.Количество() Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка обновления: в базе отсутствуют элементы классификатора.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		//КлючЗадания = "ОбновлениеТНВЭД" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеТНВЭД";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ, Состояние", КлючЗадания, СостояниеФоновогоЗадания.Активно)); 
	
	Если Задания.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОблачныеКлассификаторы.ОбновитьКлассификаторТНВЭД",,
		КлючЗадания, НСтр("ru = 'Обновление классификатора ТН ВЭД'"));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновлениеТНВЭД()
	
	Результат = ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено);

	Если Результат.Свойство("Успешно") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ТН ВЭД'"),, НСтр("ru = 'Данные классификатора успешно обновлены'"));
	ИначеЕсли Результат.Свойство("Ошибка") Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление ТН ВЭД'"),, НСтр("ru = 'Не удалось обновить данные классификатора'"));
	Иначе
		Возврат;
	КонецЕсли;
		
	Элементы.ДлительнаяОперацияОбновлениеТНВЭД.Видимость = Ложь;
	Элементы.ОбновитьТНВЭД.Доступность = Истина;
	АктуализироватьСостояниеОбновленияТНВЭД();
	
	ОтключитьОбработчикОжидания("ПроверитьОбновлениеТНВЭД");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОбновлениеТНВЭДНаСервере(РазделениеВключено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РазделениеВключено Тогда
		//КлючЗадания = "ОбновлениеТНВЭД" + Строка(ПараметрыСеанса.ОбластьДанныхЗначение);
	Иначе
		КлючЗадания = "ОбновлениеТНВЭД";
	КонецЕсли;
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ", КлючЗадания));
	
	Результат = Новый Структура;
	
	Если Не Задания.Количество() 
		Или Задания[0].Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Результат.Вставить("Ошибка");
	ИначеЕсли Задания[0].Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Успешно");
	ИначеЕсли Задания[0].Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Результат.Вставить("Активно");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура АктуализироватьСостояниеОбновленияТНВЭД()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДатаПоследнегоОбновленияТНВЭД = МестноеВремя(Константы.ДатаСинхронизацииТНВЭД.Получить(), ЧасовойПоясСеанса());
	
	Если ЗначениеЗаполнено(ДатаПоследнегоОбновленияТНВЭД) Тогда	
		Элементы.СостояниеОбновленияТНВЭД.Заголовок = СтрШаблон(НСтр("ru = 'Последнее обновление %1'"), Формат(ДатаПоследнегоОбновленияТНВЭД, "ДЛФ=DDT"));
	Иначе
		Элементы.СостояниеОбновленияТНВЭД.Заголовок = НСтр("ru = 'Обновление не выполнялось'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.ВвестиКонтрольЗапретаСтавкиПоШтатномуРасписанию.Доступность = НаборКонстант.ФункциональнаяОпцияВестиШтатноеРасписание;
	Элементы.ВвестиКонтрольЗапретаРазмераПоШтатномуРасписанию.Доступность = НаборКонстант.ФункциональнаяОпцияВестиШтатноеРасписание;
	
	Элементы.КурсыВалютЗаработнаяПлата.Видимость = НаборКонстант.ФункциональнаяОпцияУчетЗаработнойПлатыВВалюте;
	
	Элементы.ИспользуютсяПодарочныеСертификаты.Доступность = НаборКонстант.ФункциональнаяОпцияВестиРозничныеПродажи;
	Элементы.НастройкаДляРозничныхПродаж.Видимость = НаборКонстант.ФункциональнаяОпцияВестиРозничныеПродажи;	
КонецПроцедуры 

// Процедура заполняет список выбора Точность цены
//
&НаСервере
Процедура ЗаполнитьСписокВыбораТочностьЦены()

	Элементы.ТочностьЦены.СписокВыбора.Очистить();

	ЗначенияТочностиЦены = Ценообразование.ЗначенияТочностиЦены();
	Для Каждого ЗначениеТочностиЦены Из ЗначенияТочностиЦены Цикл 
		Элементы.ТочностьЦены.СписокВыбора.Добавить(ЗначениеТочностиЦены.Значение, ЗначениеТочностиЦены.Представление);
	КонецЦикла;	

КонецПроцедуры // ЗаполнитьСписокВыбораТочностьЦены()

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если Результат.Свойство("ТекстОшибки") Тогда
		
		// Нет возможности использовать ОбщегоНазначенияКлиентСервер.СообщитьПользователю, 
		// так как требуется передать UID формы
		ПользовательскоеСообщение = Новый СообщениеПользователю;
		Результат.Свойство("Поле", ПользовательскоеСообщение.Поле);
		Результат.Свойство("ТекстОшибки", ПользовательскоеСообщение.Текст);
		ПользовательскоеСообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		ПользовательскоеСообщение.Сообщить();
		
		ОбновлятьИнтерфейс = Ложь;
		
	КонецЕсли;
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	ПроверитьВозможностьИзменитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	// Добавление записи курса валют для учета заработной платы в валюте.
	Если РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетЗаработнойПлатыВВалюте" Тогда 
		Если Константы.ФункциональнаяОпцияУчетЗаработнойПлатыВВалюте.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетЗаработнойПлатыВВалюте Тогда
			
			Если НаборКонстант.ФункциональнаяОпцияУчетЗаработнойПлатыВВалюте Тогда 
				ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
				
				НаборЗаписей = РегистрыСведений.КурсыВалютЗаработнаяПлата.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Валюта.Установить(ВалютаРегламентированногоУчета);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = НачалоГода(ТекущаяДатаСеанса());
				НоваяЗапись.Валюта = ВалютаРегламентированногоУчета;
				НоваяЗапись.Курс = 1;
				НоваяЗапись.Кратность = 1;
			Иначе 
				НаборЗаписей = РегистрыСведений.КурсыВалютЗаработнаяПлата.СоздатьНаборЗаписей();
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
			КонецЕсли;
			
			Попытка
				НаборЗаписей.Записать();	
			Исключение
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись курсов валют по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			КонецПопытки;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Результат.Свойство("ТекущееЗначение") Тогда
		// Откат значения к предыдущему
		ВернутьЗначениеРеквизитаФормы(РеквизитПутьКДанным, Результат.ТекущееЗначение);
	Иначе
		СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
		
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Инициализация проверки на возможность снятия опции.
//
&НаСервере
Функция ПроверитьВозможностьИзменитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям" Тогда
		Если Константы.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.Получить());
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ" Тогда
		Если Константы.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.Получить() <> НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ.Получить());
			КонецЕсли;
		КонецЕсли;		
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.РазрешитьДублированиеНоменклатуры" Тогда
		Если Константы.РазрешитьДублированиеНоменклатуры.Получить() <> НаборКонстант.РазрешитьДублированиеНоменклатуры
			И НЕ НаборКонстант.РазрешитьДублированиеНоменклатуры Тогда
			ТекстОшибки = ОтказИзменитьРазрешитьДублированиеНоменклатуры();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.РазрешитьДублированиеНоменклатуры.Получить());
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ВалютаРегламентированногоУчета" Тогда
		Если Константы.ВалютаРегламентированногоУчета.Получить() <> НаборКонстант.ВалютаРегламентированногоУчета Тогда
			ТекстОшибки = ОтказИзменитьВалютаРегламентированногоУчета();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ВалютаРегламентированногоУчета.Получить());
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		Если Константы.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.Получить() <> НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений
			И НЕ НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений Тогда
			ТекстОшибки = ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений();
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				
				Результат.Вставить("Поле", 				РеквизитПутьКДанным);
				Результат.Вставить("ТекстОшибки", 		ТекстОшибки);
				Результат.Вставить("ТекущееЗначение",	Константы.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.Получить());
			КонецЕсли;
		КонецЕсли; 	
	КонецЕсли;
	
КонецФункции // ПроверитьВозможностьИзменитьЗначениеРеквизита()

&НаСервере
// Проверка на возможность изменения ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям.
//
Функция ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МестонахождениеОС.Организация
		|ИЗ
		|	РегистрСведений.МестонахождениеОС КАК МестонахождениеОС";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть проведенные документы по основным средствам. Изменение учета движений запрещено.'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьФункциональнаяОпцияУчетДвиженияОСПоПодразделениям()

&НаСервере
// Проверка на возможность изменения ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений.
//
Функция ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДополнительныеРасходы.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДополнительныеРасходы КАК ДополнительныеРасходы
		|ГДЕ
		|	ДополнительныеРасходы.Проведен";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть проведенные документы ""Дополнительные расходы"". Изменение учета движений запрещено.'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьФункциональнаяОпцияДопРасходыНаНесколькоПоступлений()

&НаСервере
// Проверка на возможность изменения РазрешитьДублированиеНоменклатуры.
//
Функция ОтказИзменитьРазрешитьДублированиеНоменклатуры()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Ссылка,
		|	Номенклатура.Наименование КАК Наименование
		|ПОМЕСТИТЬ ВременнаяТаблицаНоменклатура
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВременнаяТаблицаНоменклатура.Ссылка КАК Ссылка,
		|	ВременнаяТаблицаНоменклатура.Наименование КАК Наименование
		|ИЗ
		|	ВременнаяТаблицаНоменклатура КАК ВременнаяТаблицаНоменклатура
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНоменклатура КАК ВременнаяТаблицаНоменклатураДубли
		|		ПО (НЕ ВременнаяТаблицаНоменклатура.Ссылка = ВременнаяТаблицаНоменклатураДубли.Ссылка)
		|			И ВременнаяТаблицаНоменклатура.Наименование = ВременнаяТаблицаНоменклатураДубли.Наименование";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть номенклатура с дублированием наименования. Изменение запрещено.'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьРазрешитьДублированиеНоменклатуры()

&НаСервере
// Проверка на возможность изменения ВалютаРегламентированногоУчета.
//
Функция ОтказИзменитьВалютаРегламентированногоУчета()
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Ссылка
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Валютный";
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	МассивВалютныхСчетов = РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ХозрасчетныйОбороты.Валюта КАК Валюта
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(, , , Счет В (&МассивВалютныхСчетов), , , , ) КАК ХозрасчетныйОбороты";
	Запрос.УстановитьПараметр("МассивВалютныхСчетов", МассивВалютныхСчетов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В базе есть документы с использованием валют. Изменение запрещено.'");	
	КонецЕсли;
	
	Возврат ТекстСообщения;
КонецФункции // ОтказИзменитьВалютаРегламентированногоУчета()

&НаСервере
// Процедура присваивает переданное значение реквизиту формы
//
// Используется в случае, если новое значение не прошло проверку
//
//
Процедура ВернутьЗначениеРеквизитаФормы(РеквизитПутьКДанным, ТекущееЗначение)
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВалютаРегламентированногоУчета" Тогда
		НаборКонстант.ВалютаРегламентированногоУчета = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям" Тогда
		НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоПодразделениям = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ" Тогда
		НаборКонстант.ФункциональнаяОпцияУчетДвиженияОСПоМОЛ = ТекущееЗначение;
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияВестиУчетОСПоКомплектам" Тогда
		НаборКонстант.ФункциональнаяОпцияВестиУчетОСПоКомплектам = ТекущееЗначение;		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		НаборКонстант.ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений = ТекущееЗначение;
	КонецЕсли;
	
КонецПроцедуры // ВернутьЗначениеРеквизитаФормы()

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура("ИмяСобытия, Параметр, Источник", "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
	КонецЕсли;
	
	// Изменение значений связанных констант.
	Если КонстантаИмя = "ФункциональнаяОпцияДопРасходыНаНесколькоПоступлений" Тогда
		КонстантаМенеджер = Константы.ФункциональнаяОпцияДопРасходыНаОдноПоступление;
		КонстантаЗначение = НЕ НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	ИначеЕсли КонстантаИмя = "ВвестиКонтрольЗапретаСтавкиПоШтатномуРасписанию"
		И НЕ КонстантаЗначение Тогда
		КонстантаМенеджер = Константы.ВвестиКонтрольЗапретаРазмераПоШтатномуРасписанию;
		КонстантаЗначение = Ложь;
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	ИначеЕсли КонстантаИмя = "ФункциональнаяОпцияВестиРозничныеПродажи"
		И НЕ КонстантаЗначение Тогда
		КонстантаМенеджер = Константы.ИспользуютсяПодарочныеСертификаты;
		КонстантаЗначение = Ложь;
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

// Поиск и очистка префиксов справочника кассы и банковские счета
//
&НаСервере
Процедура ВыполнитьПроверкуПрефиксов()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БанковскиеСчета.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.БанковскиеСчета КАК БанковскиеСчета
	               |ГДЕ
	               |	БанковскиеСчета.Владелец ССЫЛКА Справочник.Организации
	               |	И БанковскиеСчета.Префикс <> """"
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	Кассы.Ссылка
	               |ИЗ
	               |	Справочник.Кассы КАК Кассы
	               |ГДЕ
	               |	Кассы.Префикс <> """"";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Префикс = "";
		БухгалтерскийУчетСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	КонецЦикла;	

КонецПроцедуры // ВыполнитьПроверкуПрефиксов()

#КонецОбласти


