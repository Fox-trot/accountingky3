﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Облачные классификаторы".
// ОбщийМодуль.ОблачныеКлассификаторыКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область КлассификаторТНВЭД

// Открытие формы подбора элементов классификатора ТН ВЭД из сервиса.
//
// Параметры:
//  НастройкиРежима	 - Структура - (необязательный) настройки режима открытия формы, ключи:
//                     АльтернативныйСпособПодбора  - ОписаниеОповещения - процедура открытия альтернативной
//                                                    формы подбора элементов классификатора (например,
//                                                    подбора из макета); в случае передачи параметра,
//                                                    будет выполнена проверка использования функциональной
//                                                    опции ИспользоватьСервисРаботаСНоменклатурой,
//                                                    входа в ИПП, а также доступности сервиса 1С:Номенклатура;
//                                                    при положительном результате проверки открыта форма подбора
//                                                    из сервиса, иначе - выполнена обработка оповещения;
//                     РежимВыбораЭлемента          - Булево - открытие формы в режиме выбора элемента
//                                                    вместо режима подбора и загрузки данных в базу;
//                     КодВыбранногоЭлемента        - Строка - код элемента классификатора, на котором
//                                                    необходимо спозиционироваться при открытии формы
//                                                    (только для РежимВыбораЭлемента = Истина);
//                     Владелец                     - УправляемаяФорма - владелец открываемой формы;
//                     ОбработчикЗавершения         - ОписаниеОповещения - описание оповещения, которое
//                                                    будет выполнено после интерактивного выбора элемента
//                                                    в форме (только для РежимВыбораЭлемента = Истина).
//                                                    В параметр Результат обработчика будет возвращена
//                                                    структура с данными выбранного элемента.
//                                                    Ключи структуры идентичны именам колонок таблицы значений,
//                                                    см. СоздатьОбновитьЭлементыТНВЭД() общего модуля
//                                                    ОблачныеКлассификаторыПереопределяемый.
//
Процедура ПодобратьИзСервисаЭлементыТНВЭД(НастройкиРежима = Неопределено) Экспорт
		
	Если НастройкиРежима = Неопределено Тогда
		НастройкиРежима = Новый Структура;
	КонецЕсли;
	
	Если Не НастройкиРежима.Свойство("АльтернативныйСпособПодбора") Тогда
		НастройкиРежима.Вставить("АльтернативныйСпособПодбора");
	КонецЕсли;
	
	Если Не НастройкиРежима.Свойство("РежимВыбораЭлемента") Тогда
		НастройкиРежима.Вставить("РежимВыбораЭлемента", Ложь);
	КонецЕсли;
	
	Если Не НастройкиРежима.Свойство("КодВыбранногоЭлемента") Тогда
		НастройкиРежима.Вставить("КодВыбранногоЭлемента", "");
	КонецЕсли;
	
	Если Не НастройкиРежима.Свойство("Владелец") Тогда
		НастройкиРежима.Вставить("Владелец");
	КонецЕсли;
	
	Если Не НастройкиРежима.Свойство("ОбработчикЗавершения") Тогда
		НастройкиРежима.Вставить("ОбработчикЗавершения");
	КонецЕсли;
	
	Если НастройкиРежима.АльтернативныйСпособПодбора = Неопределено Тогда
		НачатьПодборИзСервисаЭлементовТНВЭД(НастройкиРежима);
	Иначе
		
		Если ОблачныеКлассификаторыСлужебныйВызовСервера.ДоступенОнлайнПодборИзКлассификатораТНВЭД() Тогда
			НачатьПодборИзСервисаЭлементовТНВЭД(НастройкиРежима);
		Иначе
			ВыполнитьОбработкуОповещения(НастройкиРежима.АльтернативныйСпособПодбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КлассификаторОКПД2 

// Открытие формы подбора элементов классификатора из сервиса.
//
// Параметры:
//  НастройкиРежима - Структура - (необязательный) настройки режима открытия формы, ключи:
//                    ЗагружатьСИерархией          - Булево - определяет, будут ли при загрузке из облачного классификатора
//                                                   переноситься только выделенные элементы или еще и все их предки.	
//                    АльтернативныйСпособПодбора  - ОписаниеОповещения - процедура открытия альтернативной
//                                                   формы подбора элементов классификатора (например,
//                                                   подбора из макета); в случае передачи параметра,
//                                                   будет выполнена проверка использования функциональной
//                                                   опции ИспользоватьСервисРаботаСНоменклатурой,
//                                                   входа в ИПП, а также доступности сервиса 1С:Номенклатура;
//                                                   при положительном результате проверки открыта форма подбора
//                                                   из сервиса, иначе - выполнена обработка оповещения;
//                    РежимВыбораЭлемента          - Булево - открытие формы в режиме выбора элемента
//                                                   вместо режима подбора и загрузки данных в базу;
//                    КодВыбранногоЭлемента        - Строка - код элемента классификатора, на котором
//                                                   необходимо спозиционироваться при открытии формы
//                                                   (только для РежимВыбораЭлемента = Истина);
//                    Владелец                     - УправляемаяФорма - владелец открываемой формы;
//                    ОбработчикЗавершения         - ОписаниеОповещения - описание оповещения, которое
//                                                   будет выполнено после интерактивного выбора элемента
//                                                   в форме (только для РежимВыбораЭлемента = Истина).
//                                                   В параметр Результат обработчика будет возвращена
//                                                   структура с данными выбранного элемента.
//                                                   Ключи структуры идентичны именам колонок таблицы значений,
//                                                   см. СоздатьОбновитьЭлементыТНВЭД() общего модуля
//                                                   ОблачныеКлассификаторыПереопределяемый.
//
Процедура ПодобратьИзСервисаЭлементыОКПД2(НастройкиРежима = Неопределено) Экспорт
		
	ПараметрыВызоваФормы = ПараметрыВызоваФормыОКПД2();
	ЗаполнитьЗначенияСвойств(ПараметрыВызоваФормы, НастройкиРежима);						
	
	Если ПараметрыВызоваФормы.АльтернативныйСпособПодбора = Неопределено Тогда
		НачатьПодборИзСервисаЭлементовОКПД2(ПараметрыВызоваФормы);
	Иначе
		Если ОблачныеКлассификаторыСлужебныйВызовСервера.ДоступенОнлайнПодборИзОКПД2() Тогда
			НачатьПодборИзСервисаЭлементовОКПД2(ПараметрыВызоваФормы);
		Иначе
			ВыполнитьОбработкуОповещения(ПараметрыВызоваФормы.АльтернативныйСпособПодбора);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру настроек для открытия формы работы с классификатором ОКПД 2
//
// Возвращаемое значение:
//  Структура - настройки открытия формы по умолчанию:
//      * ОткрытиеЧерезОбщуюКоманду - Булево - признак того, что форма была вызвана из общей команды.
//          Если Истина - после загрузки элементов в базу данных форма не будет закрыта.
//      * АльтернативныйСпособПодбора - ОписаниеОповещения - оповещение, которое должно отработать 
//          в том случае, если сервис 1С:Номенклатура не доступен.
//      * ЗагружатьСИерархией - Булево - признак переноса всей иерархии загружаемого элементы. 
//          Если Истина то при загрузке элемента в базу будут перенесены все его предки.
//          Также значение данного параметра должно быть Истина в том случае,
//          если требуется выбирать групповые элементы
//      * РежимВыбораЭлемента - Булево - признак того, что форма открывается в режиме выбора одного 
//          конкретного элемента, а не для загрузки классификатора в базу
//      * ОбработчикЗавершения - ОписаниеОповещения -  оповещение, которое должно отработать 
//          после выбора элемента классификатора (в режиме выбора элемента).
//      * КодВыбранногоЭлемента - Строка - код элемента классификатора, 
//          на котором нужно спозиционироваться при открытии
//      * Владелец - Форма - форма, из которой вызывается подбор элементов классификатора
//
Функция ПараметрыВызоваФормыОКПД2() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ОткрытиеЧерезОбщуюКоманду", Ложь);
	Результат.Вставить("АльтернативныйСпособПодбора", Неопределено);
	Результат.Вставить("ЗагружатьСИерархией", Ложь);
	Результат.Вставить("РежимВыбораЭлемента", Ложь);
	Результат.Вставить("КодВыбранногоЭлемента", "");
	Результат.Вставить("ОбработчикЗавершения", Неопределено);
	Результат.Вставить("Владелец", Неопределено);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область КлассификаторТНВЭД

Процедура ПолучитьРазделыТНВЭД(ОповещениеОЗавершении, Форма, ИдентификаторЗадания = Неопределено,
		КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьРазделыТНВЭДВФоне(
		Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется" Тогда
		КоличествоЗаданий = КоличествоЗаданий + 1;
	КонецЕсли;
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершение",
	РаботаСНоменклатуройКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ДлительнаяОперацияЗавершение,
	ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПолучитьПодчиненныеЭлементыТНВЭД(Код, ОповещениеОЗавершении, Форма, ИдентификаторЗадания = Неопределено,
		КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьПодчиненныеЭлементыТНВЭДВФоне(Код,
		Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется" Тогда
		КоличествоЗаданий = КоличествоЗаданий + 1;
	КонецЕсли;
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершение",
	РаботаСНоменклатуройКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ДлительнаяОперацияЗавершение,
	ПараметрыОжидания);
	
КонецПроцедуры

Процедура ОбработатьПоисковыйЗапросТНВЭД(СтрокаПоиска, НомерСтраницы, ОповещениеОЗавершении, Форма,
		ИдентификаторЗадания = Неопределено, КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ОбработатьПоисковыйЗапросТНВЭДВФоне(СтрокаПоиска,
		НомерСтраницы, Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется" Тогда
		КоличествоЗаданий = КоличествоЗаданий + 1;
	КонецЕсли;
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершение",
	РаботаСНоменклатуройКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ДлительнаяОперацияЗавершение,
	ПараметрыОжидания);
	
КонецПроцедуры

Процедура ПолучитьВеткуТНВЭД(Код, АдресКэша, РежимВыбораЭлемента, ОповещениеОЗавершении, Форма,
		ИдентификаторЗадания = Неопределено, КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьВеткуТНВЭДВФоне(Код, АдресКэша,
		РежимВыбораЭлемента, Форма.УникальныйИдентификатор, ИдентификаторЗадания);
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется" Тогда
		КоличествоЗаданий = КоличествоЗаданий + 1;
	КонецЕсли;
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершение",
	РаботаСНоменклатуройКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ДлительнаяОперацияЗавершение,
	ПараметрыОжидания);
	
КонецПроцедуры

Процедура ЗагрузитьВБазуДанныеТНВЭД(АдресКэша, ВыбранныеЭлементы, ОповещениеОЗавершении, Форма,
		ИдентификаторЗадания = Неопределено, ОбновитьКэш = Ложь) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ЗагрузитьВБазуДанныеТНВЭДВФоне(АдресКэша,
		ВыбранныеЭлементы, Форма.УникальныйИдентификатор, ИдентификаторЗадания, ОбновитьКэш);
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ОповещениеОЗавершении,
	ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область КлассификаторОКПД2 

Процедура ПолучитьРазделыОКПД2(ОповещениеОЗавершении, Форма, ИдентификаторЗадания = Неопределено, 
	КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьРазделыОКПД2ВФоне(
		Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
	ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении, КоличествоЗаданий);
	
КонецПроцедуры

Процедура ПолучитьПодчиненныеЭлементыОКПД2(Код, ОповещениеОЗавершении, Форма, 
	ИдентификаторЗадания = Неопределено, КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьПодчиненныеЭлементыОКПД2ВФоне( 
		Код, Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
	ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении, КоличествоЗаданий);
	
КонецПроцедуры

Процедура ОбработатьПоисковыйЗапросОКПД2(СтрокаПоиска, НомерСтраницы, ОповещениеОЗавершении, Форма,
		ИдентификаторЗадания = Неопределено, КоличествоЗаданий = 0) Экспорт
		
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ОбработатьПоисковыйЗапросОКПД2ВФоне( 
		СтрокаПоиска, НомерСтраницы, Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
	ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении, КоличествоЗаданий);	
	
КонецПроцедуры

Процедура ПолучитьВеткуОКПД2(Код, АдресКэша, РежимВыбораЭлемента, ОповещениеОЗавершении, Форма,
		ИдентификаторЗадания = Неопределено, КоличествоЗаданий = 0) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ПолучитьВеткуОКПД2ВФоне(Код, АдресКэша,
		РежимВыбораЭлемента, Форма.УникальныйИдентификатор, ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения    = Истина;
		
	ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении, КоличествоЗаданий);	
	
КонецПроцедуры

Процедура ЗагрузитьВБазуДанныеОКПД2(ПараметрыЗагрузки,	ОповещениеОЗавершении, Форма, 
	ИдентификаторЗадания = Неопределено, ОбновитьКэш = Ложь) Экспорт
	
	ДлительнаяОперация = ОблачныеКлассификаторыСлужебныйВызовСервера.ЗагрузитьВБазуДанныеОКПД2ВФоне(
		ПараметрыЗагрузки, Форма.УникальныйИдентификатор, ИдентификаторЗадания, ОбновитьКэш);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьСообщения = Истина;
		
	ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении);	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КлассификаторТНВЭД

Процедура НачатьПодборИзСервисаЭлементовТНВЭД(НастройкиРежима)

	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
	"ОбщийМодуль.ОблачныеКлассификаторыКлиент.НачатьПодборИзСервисаЭлементовТНВЭД");
	
	ПараметрыОткрытия = Новый Структура("РежимВыбораЭлемента, КодВыбранногоЭлемента",
		НастройкиРежима.РежимВыбораЭлемента, НастройкиРежима.КодВыбранногоЭлемента);
	
	ОткрытьФорму("Обработка.РаботаСОблачнымиКлассификаторами.Форма.КлассификаторТНВЭД", ПараметрыОткрытия,
		НастройкиРежима.Владелец,,,, НастройкиРежима.ОбработчикЗавершения);

КонецПроцедуры

#КонецОбласти

#Область КлассификаторОКПД2 

Процедура НачатьПодборИзСервисаЭлементовОКПД2(НастройкиРежима)

	ПараметрыОткрытия = Новый Структура("РежимВыбораЭлемента, КодВыбранногоЭлемента, ЗагружатьСИерархией",
		НастройкиРежима.РежимВыбораЭлемента, НастройкиРежима.КодВыбранногоЭлемента, НастройкиРежима.ЗагружатьСИерархией);
	
	ОткрытьФорму("Обработка.РаботаСОблачнымиКлассификаторами.Форма.КлассификаторОКПД2", ПараметрыОткрытия,
		НастройкиРежима.Владелец,,,, НастройкиРежима.ОбработчикЗавершения);

КонецПроцедуры

Процедура ЗапуститьДлительнуюОперацию(ДлительнаяОперация, ПараметрыОжидания, ОповещениеОЗавершении, 
	КоличествоЗаданий = Неопределено)
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	ОповещениеОЗавершении.ДополнительныеПараметры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	ОчиститьСообщения();
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполняется"
		И КоличествоЗаданий <> Неопределено Тогда
		КоличествоЗаданий = КоличествоЗаданий + 1;
	КонецЕсли;
		
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершение",
	РаботаСНоменклатуройКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
	ДлительнаяОперацияЗавершение,
	ПараметрыОжидания);
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти